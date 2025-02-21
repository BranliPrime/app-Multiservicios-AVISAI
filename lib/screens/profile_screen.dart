import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  TextEditingController nombreController = TextEditingController(text: "Michael Jackson");
  TextEditingController apellidoController = TextEditingController(text: "Mamani");
  TextEditingController contactoController = TextEditingController(text: "987654321");


  late String originalNombre;
  late String originalApellido;
  late String originalContacto;

  void toggleEdit() {
    setState(() {
      if (isEditing) {
        // Guardar los cambios (puedes enviarlos a una base de datos aquí)
        print("Guardado: ${nombreController.text}, ${apellidoController.text}, ${contactoController.text}");
      } else {
        // Guardar valores originales para poder restaurarlos al cancelar
        originalNombre = nombreController.text;
        originalApellido = apellidoController.text;
        originalContacto = contactoController.text;
      }
      isEditing = !isEditing;
    });
  }

  void cancelEdit() {
    setState(() {
      isEditing = false;
      nombreController.text = originalNombre;
      apellidoController.text = originalApellido;
      contactoController.text = originalContacto;
    });
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        isEditing
            ? TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              )
            : Text(controller.text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de perfil y datos personales
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'lib/assets/images/profile.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombreController.text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(apellidoController.text, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            //  Campos de información
            _buildField("Nombre", nombreController),
            _buildField("Apellido", apellidoController),
            _buildField("Contacto", contactoController),

            const SizedBox(height: 20),

            Center(
              child: isEditing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: toggleEdit,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: Text("Guardar"),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: cancelEdit,
                          child: Text("Cancelar"),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: toggleEdit,
                      child: Text("Editar Perfil"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
