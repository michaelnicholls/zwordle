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
          DATA target TYPE c LENGTH 40.
          DATA rc LIKE sy-subrc.
          IF lt_filter_ranges IS NOT INITIAL.
            READ TABLE lt_filter_ranges WITH KEY name = 'NEWWORD' ASSIGNING  FIELD-SYMBOL(<newword>).
            READ TABLE lt_filter_ranges WITH KEY name = 'GUESSES' ASSIGNING FIELD-SYMBOL(<guesses>).
          ENDIF.
          IF <newword> IS ASSIGNED AND <newword>-range[ 1 ]-low = 'X'.
            target = lcl_things=>getword(  ).
            CALL FUNCTION 'G_SET_USER_PARAMETER' EXPORTING parameter_id = 'WORDLE' parameter_value = target.
          ENDIF.
          CALL FUNCTION 'G_GET_USER_PARAMETER' EXPORTING parameter_id = 'WORDLE' IMPORTING parameter_value = target rc = rc.
          IF rc <> 0.
            lt_data = VALUE #( ( line = 10 text = 'Please use the flag to set a target' ) ).

          ELSEIF <guesses> IS ASSIGNED.
            IF lines( <guesses>-range ) > 6.
              lt_data = VALUE #( ( line = 10 text = 'Please enter up to 6 guesses' ) ) .
            ELSE.
              DO lines(  <guesses>-range ) TIMES.
                DATA(status) = target && `         `.
                DATA(guess) = replace( val =  to_upper( <guesses>-range[ sy-index ]-low ) sub = ` ` with = `` occ = 0 ).
                DATA(fullguess) = guess && `        `.
                IF strlen( guess ) < 5.
                  status = 'Guess too short'.

                ENDIF.
                linecounter += 1.
                " criticality 0 is gray, 1 is red, 2 is orange, 3 is green
                DATA(c1) = 0.
                DATA(c2) = 0.
                DATA(c3) = 0.
                DATA(c4) = 0.
                DATA(c5) = 0.
                DATA(t1) = substring(  val = fullguess off = 0 len = 1 ) .
                DATA(t2) = substring(  val = fullguess  off = 1 len = 1 ).
                DATA(t3) = substring(  val = fullguess off = 2 len = 1 ).
                DATA(t4) = substring(  val = fullguess off = 3 len = 1 ).
                DATA(t5) = substring(  val = fullguess off = 4 len = 1 ).
                data(lt_target) = value string_table( for i = 0 while i < 5 (  substring(  val = target off = i len = 1 ) ) ).
                IF t1 = target(1). c1 = 3. lt_target[ 1 ] = '_'. ENDIF.
                IF t2 = target+1(1). c2 = 3. lt_target[ 2 ] = '_'. ENDIF.
                IF t3 = target+2(1). c3 = 3. lt_target[ 3 ] = '_'. ENDIF.
                IF t4 = target+3(1). c4 = 3. lt_target[ 4 ] = '_'.  ENDIF.
                IF t5 = target+4(1). c5 = 3. lt_target[ 5 ] = '_'. ENDIF.

                find FIRST OCCURRENCE OF t1 in TABLE lt_target MATCH LINE data(matchline).
                if sy-subrc = 0. c1 = 2. lt_target[ matchline ] = '_'. endif.
                find FIRST OCCURRENCE OF t2 in TABLE lt_target MATCH LINE matchline.
                if sy-subrc = 0. c2 = 2. lt_target[ matchline ] = '_'. endif.
                find FIRST OCCURRENCE OF t3 in TABLE lt_target MATCH LINE matchline.
                if sy-subrc = 0. c3 = 2. lt_target[ matchline ] = '_'. endif.
                find FIRST OCCURRENCE OF t4 in TABLE lt_target MATCH LINE matchline.
                if sy-subrc = 0. c4 = 2. lt_target[ matchline ] = '_'. endif.
                find FIRST OCCURRENCE OF t5 in TABLE lt_target MATCH LINE matchline.
                if sy-subrc = 0. c5 = 2. lt_target[ matchline ] = '_'. endif.

                lt_data = VALUE #( BASE lt_data  ( line = linecounter
                char1 = t1 char2 = t2 char3 = t3 char4 = t4 char5 = t5
                crit1 = c1 crit2 = c2 crit3 = c3 crit4 = c4 crit5 = c5 text = status ) ).
              ENDDO.
            ENDIF.
          ELSE.
            lt_data = VALUE #( ( line = 10 text = 'Please enter up to 6 guesses' ) ) .
          ENDIF.
          io_response->set_data( lt_data ).
          io_response->set_total_number_of_records( lines( lt_data ) ).
        ENDIF.
      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
