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
              lt_data = value #( ( line = 10 text = | Target {  target } Guesses { lines( <guesses>-range ) } | ) ).
          else.
           lt_data = value #( ( line = 10 text = 'Please enter some guesses' ) ) .
          ENDIF.
          io_response->set_data( lt_data ).
          io_response->set_total_number_of_records( lines( lt_data ) ).
        ENDIF.
      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
