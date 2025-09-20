El servidor valida la firma con la clave pública registrada.

La app del sistema (Face ID, huella, PIN) desbloquea el uso de la clave privada.

Resultado:

No se transmite contraseña.

El servidor nunca ve datos biométricos ni secretos.

Es resistente a phishing y robo de credenciales.

Ejemplo real

Apple: “Inicia sesión con Passkey” usando Face ID o Touch ID en Safari o apps.

Google: Login en Gmail pide “usar huella” en lugar de contraseña.

Microsoft: Acceso a Outlook con Windows Hello (rostro o PIN).

Caso en Avanzza 2.0

El conductor instala la app.

Al crear cuenta, el teléfono genera el par de claves. La pública se guarda en Avanzza.

En el siguiente login:

La app muestra “Usa Face ID para entrar a Avanzza”.

El Face ID desbloquea la clave privada.

El servidor valida con la clave pública.

El usuario nunca escribió una contraseña ni dependió de un SMS.

¿Quieres que te arme un flujo comparativo Passkey vs Contraseña+SMS para que veas ventajas concretas de aplicarlo en Avanzza 2.0?

-----------------------------------------------------------------------
