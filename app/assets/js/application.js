$(document).ready(function() {
  $(document).on('submit', '#search-user', function(event) {
    event.preventDefault();

    var formData = $('#search-user').serialize();
    $.ajax({
      type: 'POST',
      url: $('#search-user').attr('action'),
      data: formData
    }).done(function(data) {
      if(typeof data === 'object') {
        $('#result-search')
        .html('<p>Find user:' + data.name + '</p> <button id="track" data-id="' + data.id + '" data-name="' + data.name + '">Track user</button>')
      } else {
        $('#result-search').html(data)
      }
    })
  })


  $(document).on('click', '#track', function(event) {
    $.ajax({
      type: 'POST',
      url: '/twitter/track_user',
      data: { twitter_id: $('#track').attr('data-id'), name:  $('#track').attr('data-name')}
    }).done(function(data) {
      console.log(data)
      $('#result-search').html(data)
    })
  })

  $(document).on('click', '#untrack', function(event) {
    $.ajax({
      type: 'DELETE',
      url: '/twitter/untrack_user',
      data: { id: $('#untrack').attr('value') }
    }).done(function(data) {
      $('#'+ data.id).html('')
      console.log(data)
    })
  })
})
