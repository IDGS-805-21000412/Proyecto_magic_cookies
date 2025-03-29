from wtforms import Form
from flask_wtf import FlaskForm
from wtforms import StringField, FloatField, SelectField
from wtforms import validators

class nuevaVenta(FlaskForm):          
    producto = SelectField('', choices=[], validators=[validators.DataRequired(message='Seleccione un producto')])  
    tipo = SelectField('', choices=[], validators=[validators.DataRequired(message='Seleccione un producto')])  
    cantidad = FloatField('Cantidad', [validators.DataRequired(message='Campo requerido'),validators.NumberRange(min=1, message="La cantidad debe ser mayor a 0")])  # Validación para cantidad mayor a 0
