$().ready(function () {
    ajaxify_batch_table();
});

var debug = function (msg) {
  if (typeof(console) == "object") {
      console.log(msg)
  }
};

var ajaxify_batch_table = function() {
    // var log = function (msg) { debug("ajaxify_batch_table: " + msg)};
    var batch_table = $('table.batch');
    // $bt = batch_table;
    if (batch_table.length) {
        if (! $('table.batch_done').length) {
            var header = $('h1');
            header.text('Processing batch...');
            var batch_id_field = batch_table.attr('id');
            if (batch_id_field.length) {
                var matcher = batch_id_field.match(/batch_(\d+)/);
                if (matcher) {
                    var batch_id = matcher[1];
                    // $bi = batch_id;
                    $.ajax({
                        'type': 'GET',
                        'url': '/batches/' + batch_id + '.json',
                        'success': function(msg) {
                            // $m = msg;
                            if (msg.batch['done?']) {
                                batch_table.addClass('batch_done')
                                header.text('Finished processing batch!');
                            } else {
                                setTimeout(function () {
                                    ajaxify_batch_table();
                                }, 1000);
                            }
                            update_batch_table(msg);
                        }
                    });
                }
            }
        }
    }
};

var update_batch_table = function (data) {
    for (var i in data.batch.tickets) {
        var ticket = data.batch.tickets[i];
        $('#ticket_status_for_' + ticket.id).text(ticket.status_label)
    }
}
