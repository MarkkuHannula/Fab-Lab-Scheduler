<link rel="stylesheet" type="text/css"  href="<?php echo asset_url() . "css/jquery.qtip.min.css"; ?>" />
<script src="<?php echo asset_url() . "js/jquery.qtip.min.js"; ?>"  ></script>
<script type="text/javascript" src="<?=asset_url()?>js/bootstrap-notify.min.js"></script>
<link rel="stylesheet" type="text/css" href="<?=asset_url()?>css/animate.css"/>

<script>

	function makeQtip_admin(elementId, machine, e_Start, e_End, firstname, surname, email) {
		var sModal="";
		sModal += "<p>Start time: " + e_Start + "</p>";
		sModal += "<p>End time: " + e_End + "</p>";
		sModal += "<p>First name: " + firstname + "</p>";
		sModal += "<p>Surname: " + surname + "</p>";
		sModal += "<p>Email: " + email + "</p>";
		sModal += "";
		
		$(elementId).qtip({ // Grab some elements to apply the tooltip to
			show: { 
				effect: function() { $(this).slideDown(); },
				solo: true,
	        	ready: true
	        },
	        hide: { 
	        	event: false
	        },
		    content: {
			    title: "Reservation",
		        text: sModal,
		        button: true
		    },
		    style: {
		        classes: 'qtip-bootstrap qtip_width'
			},
		    position: {
				at: 'center center',
				my: 'left center',
				viewport: jQuery(window) // Keep the tooltip on-screen at all times
		    },
		    events: {
		    	hide: function (event, api) {
			        $(this).qtip('destroy');
		    	}
			}  
		});
	}

	$(function() { // document ready
		$('#calendar').fullCalendar({
			schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
			editable: false, // enable draggable events
			allDaySlot: false,
			firstDay: 1,
            timeFormat: 'HH:mm',
            slotLabelFormat: 'HH:mm',
			aspectRatio: 2.5,
			scrollTime: '08:00', // undo default 6am scrollTime
			header: {
				left: 'today prev,next',
				center: 'title',
				right: 'timelineDay, timelineSevenDays, month'
			},
			views: {
        			timelineSevenDays: {
		            type: 'timeline',
		            duration: { days: 7 },
		            slotDuration: '02:00',
		            slotLabelFormat: [
					    'MMM DD', // top level of text
					    'HH:mm'        // lower level of text
					]
		        }
		    },
			resourceLabelText: 'Machines',
			defaultView: 'timelineDay',
			resources: { // you can also specify a plain string like 'json/resources.json'
				url: '<?php echo base_url('reservations/reserve_get_machines')?>',
				error: function() {
					$('#script-warning').show();
				}
			},
	        loading: function( isLoading, view ) {
	            if(isLoading) {
	                 $("#loader").show()
	            } else {
	                $("#loader").hide()
	            }
	        },
	        resourceGroupField: 'groupText',
            eventSources: [
            // your event source
                {
                    url: 'reserve_get_reserved_slots',
                    color: "#f0ad4e"
                },
                {
                    url: 'reserve_get_supervision_slots'
                }
            ],
            eventAfterRender : function( e, element, view ) { 
// 				console.log(element);
// 				console.log(e);
				if (e.reserved == 1)
				{
					if(e.is_admin === true) 
					{
						var machine = e.resourceId;
						var eStart = e.start.format("DD.MM.YYYY, HH:mm");//.format("dddd, MMMM Do YYYY, h:mm:ss a");
						var eEnd = e.end.format("DD.MM.YYYY, HH:mm");//.format("dddd, MMMM Do YYYY, h:mm:ss a");
						var firstname = e.first_name;
						var surname = e.surname;
						var email = e.email;
						$(element).css("cursor", "pointer");
						$(element).click(function(){ 
					        makeQtip_admin($(element), machine, eStart, eEnd, firstname, surname, email);
					    });
					}
				}
            }
		});//fullcalendar
	});//$function

</script>
<div class="container">
	<article>
		<legend>Supervision sessions</legend>
		<div id="calendar" style="position:relative"><div id="loader" class="loader" style='position:absolute;display:none;margin:auto;left: 0;top: 0;right: 0;bottom: 0;'></div></div>
	</article>	
</div>