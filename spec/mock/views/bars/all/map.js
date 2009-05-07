function(doc) {
  if(doc.type == 'Bar') {
    emit(doc.question, {
      answer : doc.answer,
      rating : doc.rating,
      created_at : doc.created_at
    });
  }
};