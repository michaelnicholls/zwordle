CLASS zcl_wordle DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_wordle IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA lt_data TYPE TABLE OF zwordle.
    TRY.
        IF io_request->is_data_requested(  ).

          DATA(lo_filter) = io_request->get_filter(  ).
            DATA(lt_filter_ranges) = lo_filter->get_as_ranges(  ).
          DATA(lt_params) = io_request->get_parameters(  ).
          DATA(lt_sort_elements)  = io_request->get_sort_elements(  ).

          DATA(lo_paging) = io_request->get_paging(  ).
          DATA(lv_offset) = lo_paging->get_offset(  ).
          DATA(lv_page_size) = lo_paging->get_page_size(  ).
          DATA(linecounter) = 0.
          DATA target type c length 40.
          data rc like sy-subrc.
          if lt_filter_ranges IS NOT INITIAL.
              read TABLE lt_filter_ranges with key name = 'NEWWORD' ASSIGNING  FIELD-SYMBOL(<newword>).
              READ table lt_filter_ranges with key name = 'GUESSES' ASSIGNING FIELD-SYMBOL(<guesses>).
          endif.
          if <newword> is ASSIGNED and <newword>-range[ 1 ]-low = 'X'.
                target = lcl_things=>getword(  ).
                call function 'G_SET_USER_PARAMETER' EXPORTING parameter_id = 'WORDLE' parameter_value = target.
          endif.
          call FUNCTION 'G_GET_USER_PARAMETER' EXPORTING parameter_id = 'WORDLE' IMPORTING parameter_value = target rc = rc.
          if rc <> 0.
                lt_data = value #( ( line = 10 text = 'Please use the flag to set a target' ) ).

          elseif <guesses> is assigned.
            if lines( <guesses>-range ) > 6.
            lt_data = value #( ( line = 10 text = 'Please enter up to 6 guesses' ) ) .
            else.
            do lines(  <guesses>-range ) times.
               data(status) = ``.
               data(guess) = replace( val =  to_upper( <guesses>-range[ sy-index ]-low ) sub = ` ` with = `` occ = 0 ).
               data(fullguess) = guess && `        `.
               if strlen( guess ) < 5.
                status = 'Guess too short'.

                endif.
                linecounter += 1.
                " criticality 0 is gray, 1 is red, 2 is orange, 3 is green
                data(c1) = 0.
                data(c2) = 2.
                data(c3) = 3.
                data(c4) = 0.
                data(c5) = 3.
                data(t1) = substring(  val = fullguess off = 0 len = 1 ) .
                 data(t2) = substring(  val = fullguess  off = 1 len = 1 ).
                 data(t3) = substring(  val = fullguess off = 2 len = 1 ).
                  data(t4) = substring(  val = fullguess off = 3 len = 1 ).
                  data(t5) = substring(  val = fullguess off = 4 len = 1 ).

              lt_data = value #( base lt_data  ( line = linecounter
              char1 = t1 char2 = t2 char3 = t3 char4 = t4 char5 = t5
              crit1 = c1 crit2 = c2 crit3 = c3 crit4 = c4 crit5 = c5 text = status ) ).
              enddo.
              endif.
          else.
           lt_data = value #( ( line = 10 text = 'Please enter up to 6 guesses' ) ) .
          ENDIF.
          io_response->set_data( lt_data ).
          io_response->set_total_number_of_records( lines( lt_data ) ).
        ENDIF.
      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
