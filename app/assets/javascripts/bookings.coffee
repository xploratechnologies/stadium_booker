$ ->
  $('.button-collapse').sideNav()
  $('.datetimepicker').datetimepicker minDate: new Date
  $('.collapsible').collapsible()
  $('body').on 'mouseover click', '.datetimepicker', ->
    $('.datetimepicker').datetimepicker minDate: new Date
    return
  $('body').on 'mouseover click', '.collapsible', ->
    $('.collapsible').collapsible()
    return
  return
