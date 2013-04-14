part of zz;

/**
 * Represents a set of blood splatter.
 */
class Blood {
  ImageElement bloodImage;
  List<vec2> bloodSpots;
  int maxSpots;
  
  /**
   * Constructs a new blood set that can contain up to [maxSpots] stains.
   */
  Blood(CanvasRenderingContext2D c, {this.maxSpots: 200}) {
    bloodSpots = new List<vec2>();
    bloodImage = null;
    
    ImageElement loadingImage = new ImageElement();
    loadingImage.src = 'img/BloodSplatter.png';
    
    loadingImage.onLoad.listen((Event e) { 
      bloodImage = loadingImage; 
    });
  }
  
  /**
   * Adds a blood spot at the given [spotLocation].
   */
  void addSpot(vec2 spotLocation) {
    while (bloodSpots.length >= maxSpots) {
      bloodSpots.removeAt(0);
    }
    
    bloodSpots.add(spotLocation);
  }
  
  void draw(World world) {
    // Wait for blood image to be loaded
    if (bloodImage == null) {
      return;
    }
    
    var imageOffset = new vec2(bloodImage.width, bloodImage.height) / 2; 
    
    for (var spot in bloodSpots) {
      var drawLocation = spot - imageOffset;
      world.context.drawImage(bloodImage, drawLocation.x, drawLocation.y);
    }
  }
}