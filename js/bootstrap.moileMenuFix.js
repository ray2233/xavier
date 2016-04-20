    
/* ---------------------------------------------------------------------- */
/*	Jquery fixes bootstrap3 menu bug
/* ---------------------------------------------------------------------- */


 if($(document).width() > 767){
    
    $('a').removeAttr( "data-toggle" )
  }
  else {
    
    $('a').attr( "title", inputTitle );
}

