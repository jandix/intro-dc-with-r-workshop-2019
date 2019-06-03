classify_image <- function (url, model) {
  
  # hash url
  hash <- digest::digest(url, algo = "sha1")
  
  # download image
  download.file(url = url, 
                destfile = hash, 
                mode = 'wb', 
                quiet = TRUE)
  
  # load downloaded image
  image <- keras::image_load(path = hash, 
                             target_size = c(224, 224))
  
  # remove image from server
  unlink(hash)
  # process image
  x <- keras::image_to_array(img = image)
  x <- keras::array_reshape(x, c(1, dim(x)))
  x <- keras::imagenet_preprocess_input(x)
  
  # predict classes  
  predictions <- predict(model, x)
  keras::imagenet_decode_predictions(predictions)[[1]]
} 






