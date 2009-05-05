function(doc) {
  if(doc.type == 'Foo' && doc.tags && doc.tags.length) {
    for(var idx in doc.tags) {
      emit(doc.tags[idx], 1);
    }
  }
}