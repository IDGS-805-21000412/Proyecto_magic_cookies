from flask import Flask, render_template, request, redirect, url_for, session, flash, g, jsonify
from flask_wtf.csrf import CSRFProtect
from config import DevelopmentConfig
from models import *
import forms
from decimal import Decimal
from datetime import date

app = Flask(__name__, template_folder="modulos")
app.config.from_object(DevelopmentConfig)
csrf = CSRFProtect()
#----------------- Funciones para registrar.html y ticket.html -----------------#
@app.route("/ventas", methods=["GET", "POST"])
def ventas():
    create_form = forms.nuevaVenta(request.form)

    # Obtener los nombres de los productos distintos
    galletas = db.session.query(Producto.nombre).distinct().all()
    create_form.producto.choices = [(g.nombre, g.nombre) for g in galletas]

    # Lista temporal para almacenar los productos seleccionados
    if 'productos_seleccionados' not in session:
        session['productos_seleccionados'] = []

    if request.method == 'POST':
        pro = request.form.get('producto')  # Obtener el nombre del producto
        tip = request.form.get('tipo')     # Obtener el tipo de producto
        cant = float(request.form.get('cantidad'))  # Obtener la cantidad solicitada
       
        # Buscar el producto en la base de datos
        galletaSelec = Producto.query.filter_by(nombre=pro, tipo=tip).first()

        if galletaSelec:
            # Calcular la cantidad seleccionada del producto en la sesión
            cantidad_seleccionada = sum(
                p['cantidad'] for p in session['productos_seleccionados'] 
                if p['nombre'] == pro and p['tipo'] == tip
            )
            
            # Calcular la cantidad restante teniendo en cuenta las ventas en proceso
            cantidad_disponible = galletaSelec.cantidad_stock - cantidad_seleccionada

            # Validar si hay suficiente stock considerando las ventas en proceso
            if cant <= cantidad_disponible:
                session['productos_seleccionados'].append({
                    'idProducto':galletaSelec.idProducto,
                    'nombre': galletaSelec.nombre,
                    'tipo': tip,
                    'cantidad': cant,
                    'precio': galletaSelec.precio,
                    'subtotal': float(galletaSelec.precio) * cant
                })
                session.modified = True  # Asegurar que la sesión se guarda

                return jsonify({
                    "status": "success",
                    "message": "Producto agregado a la venta",
                    "producto": {                        
                        'idProducto':galletaSelec.idProducto,
                        "nombre": galletaSelec.nombre,
                        "tipo": tip,
                        "cantidad": cant,
                        "precio": galletaSelec.precio,
                        "subtotal": float(galletaSelec.precio) * cant
                    },
                    "productos_seleccionados": session['productos_seleccionados']
                })
            else:
                flash(f"No hay suficiente stock disponible. Solo quedan {cantidad_disponible} unidades.", "danger")
                return jsonify({"status": "error", "message": f"No hay suficiente stock. Solo quedan {cantidad_disponible} unidades."})
        else:
            flash("Presentacion no disponible", "danger")
            return jsonify({"status": "error", "message": "Presentacion no disponible"})

    return render_template("ventas/registrar.html", form=create_form)

@app.route("/cancelar", methods=["POST"])
def cancelar():
    session.pop('productos_seleccionados', None)  # Borrar productos de la sesión
    return jsonify({"status": "success", "message": "Venta cancelada"})

@app.route("/volver", methods=["POST"])
def volver():    
    session.pop('productos_finalizados', None)
    flash("Productos eliminados correctamente", "success")
    return redirect(url_for('ventas'))


@app.route("/finalizar", methods=["POST"])
def finalizar():
    # Obtener los productos seleccionados de la sesión
    productos_seleccionados = session.get('productos_seleccionados', [])

    if productos_seleccionados:
        # Crear una nueva venta
        nueva_venta = Venta(fecha=date.today())  # Registrar la fecha actual

        # Agregar la nueva venta a la base de datos
        db.session.add(nueva_venta)
        db.session.commit()

        # Obtener el ID de la venta recién creada
        id_venta = nueva_venta.idVenta

        # Variables para calcular el total de la venta
        total_venta = 0

        # Lista para guardar los productos vendidos (para el ticket)
        productos_vendidos = []

        # Iterar sobre los productos seleccionados para restarlos del inventario
        for producto in productos_seleccionados:
            producto_db = Producto.query.get(producto['idProducto'])

            if producto_db and producto_db.cantidad_stock >= producto['cantidad']:
                # Restar la cantidad de productos del inventario
                producto_db.cantidad_stock -= producto['cantidad']

                # Crear el detalle de la venta
                detalle_venta = DetalleVenta(
                    idVenta=id_venta,
                    idProducto=producto['idProducto'],
                    cantidad=producto['cantidad'],
                    subtotal=producto['subtotal']
                )

                # Agregar el detalle a la base de datos
                db.session.add(detalle_venta)

                # Sumar al total de la venta
                total_venta += producto['subtotal']

                # Guardar el producto vendido para mostrarlo en el ticket
                productos_vendidos.append(producto)

                # Guardar los cambios en la base de datos
                db.session.commit()

            else:
                # Si no hay suficiente cantidad en stock, puedes devolver un error
                return jsonify({"status": "error", "message": f"Producto {producto_db.nombre} no tiene suficiente stock."})

        # Registrar el total de la venta (puedes agregar más campos si es necesario)
        # En este ejemplo solo se guarda la fecha y el total
        # Se podría añadir la información de costos, impuestos, etc. si es necesario

        # Guardar los productos vendidos en la sesión para mostrarlos en el ticket
        session['productos_finalizados'] = productos_vendidos

        # Limpiar la sesión de productos seleccionados
        session.pop('productos_seleccionados', None)

        # Devolver una respuesta JSON indicando éxito y redirigir a la página de ticket
        return jsonify({
            "status": "success", 
            "message": "Venta finalizada con éxito.", 
            "redirect_url": url_for('ticket')
        })
    else:
        print("No hay productos seleccionados.")
        return jsonify({"status": "error", "message": "No hay productos para vender."})

@app.route("/ticket")
def ticket():
    # Obtener los productos finalizados de la sesión
    productos_finalizados = session.get('productos_finalizados', [])

    if not productos_finalizados:
        # Redirigir a /finalizar si no hay productos finalizados
        return redirect(url_for('ventas'))

    # Calcular el total sumando los subtotales de los productos
    total = sum(float(producto['subtotal']) for producto in productos_finalizados)

    # Renderizar el template de ticket con los productos y el total
    return render_template("ventas/ticket.html", productos=productos_finalizados, total=total)

#----------------- Funciones para registrar.html y ticket.html -----------------# 
#----------------- Funciones para historial.html -----------------#
@app.route("/historial")
def historial():
    ventas_detalles = []
    ventas = Venta.query.all()  # Obtener todas las ventas

    for venta in ventas:
        detalles = DetalleVenta.query.filter_by(idVenta=venta.idVenta).all()
        detalle_venta = {
            'venta': venta,
            'detalles': [],
            'total': Decimal('0.00')  # Inicializamos el total como un Decimal
        }
        
        # Obtener detalles de productos asociados a la venta y calcular el total
        for detalle in detalles:
            producto = Producto.query.get(detalle.idProducto)
            subtotal = Decimal(detalle.cantidad) * Decimal(producto.precio)  # Convertimos a Decimal
            detalle_venta['detalles'].append({
                'producto': producto,
                'cantidad': detalle.cantidad,
                'subtotal': subtotal
            })
            detalle_venta['total'] += subtotal  # Sumamos usando Decimal
        
        ventas_detalles.append(detalle_venta)

    return render_template('ventas/historial.html', ventas_detalles=ventas_detalles)


#----------------- Funciones para historial.html -----------------#


















@app.route("/")
def home():
    return render_template("login.html")

@app.route("/inicio")
def inicio():
    return render_template("inicio.html")

@app.route("/produccion")
def produccion():
    return render_template("produccion/produccion.html")

@app.route("/CRUDproveedores")
def proveedores():
    return render_template("proveedores/CRUDproveedores.html")  

if __name__ == '__main__':
    csrf.init_app(app)
    db.init_app(app)
    with app.app_context():
        db.create_all()
    app.run(port=7000, debug=True)
    