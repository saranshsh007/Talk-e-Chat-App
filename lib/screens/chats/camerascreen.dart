import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;

class cameraScreen extends StatefulWidget {
  @override
  _cameraScreenState createState() => _cameraScreenState();
}

class _cameraScreenState extends State<cameraScreen> {

late CameraController _cameraController;
  late  Future<void> cameraValue;

  @override
  void initState() {

        super.initState();
        _cameraController = CameraController(cameras[0], ResolutionPreset.high);
         cameraValue = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : Stack(
          children: [
            FutureBuilder(
                  future: cameraValue
                ,builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done)
                {
                  return CameraPreview(_cameraController);
                }else{
                return Center(child: CircularProgressIndicator());
              }
            },),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              child: Container(
                alignment: Alignment.center,
                color: Colors.black,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.flash_off , color: Colors.white,size: 28,)),
                        InkWell(onTap: (){},child: Icon(Icons.panorama_fish_eye , color: Colors.white,size: 70,)),
                        IconButton(onPressed: (){}, icon: Icon(Icons.flip_camera_android , color: Colors.white,size: 28,))
                      ],
                    ),
                    SizedBox(height: 4,),
                    Text("Hold for video , tap for photo" , style: TextStyle(
                      color: Colors.white
                    ),textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
