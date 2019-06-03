# define model
model <- keras::application_resnet50(weights = "imagenet")

# load image functions
source("./classify_image.R")

# define router
router <- plumber::plumber$new()

# define route
router$handle("GET", "/", function (req, res, url = NULL) {
  
  # check if url is provided
  if (is.null(url)) return(list(
    code = 400,
    message = "Please provide an image URL."
  ))
  
  # classify image
  classify_image(url = url, 
                 model = model)
  
}, serializer = plumber::serializer_unboxed_json())

# start application
router$run(host = "0.0.0.0", port = 9000, swagger = FALSE)
