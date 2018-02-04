$(document).ready(function() {
  $(document).on('submit', '#search-user', function(event) {
    event.preventDefault();

    var formData = $('#search-user').serialize();
    $.ajax({
      type: 'POST',
      url: $('#search-user').attr('action'),
      data: formData
    }).done(function(data) {
      console.log(data)
      if(typeof data === 'object') {
        $('#result-search')
        .html('<p>Find user:' + data.name + '</p> <button id="track" value="' + data.id + '">Track user</button>')
      } else {
        $('#result-search').html(data)
      }
    })
  })


  $(document).on('click', '#track', function(event) {
    $.ajax({
      type: 'POST',
      url: '/twitter/track_user',
      data: { twitter_id: $('#track').attr('value') }
    }).done(function(data) {
      console.log(data)
      $('#result-search').html(data)
    })
  })
})
