*&---------------------------------------------------------------------*
*& Report Z_HIGH_SCORES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_high_scores.

CLASS zcl_high_scores DEFINITION.

  PUBLIC SECTION.
    TYPES integertab TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    METHODS constructor
      IMPORTING
        scores TYPE integertab.

    METHODS list_scores
      RETURNING
        VALUE(result) TYPE integertab.

    METHODS latest
      RETURNING
        VALUE(result) TYPE i.

    METHODS personalbest
      RETURNING
        VALUE(result) TYPE i.

    METHODS personaltopthree
      RETURNING
        VALUE(result) TYPE integertab.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA scores_list TYPE integertab.

ENDCLASS.


CLASS zcl_high_scores IMPLEMENTATION.

  METHOD constructor.
    me->scores_list = scores.
  ENDMETHOD.

  METHOD list_scores.
    result = scores_list.
  ENDMETHOD.

  METHOD latest.

    DATA(lv_len) = lines( scores_list ).
    READ TABLE me->scores_list INTO result INDEX lv_len.
    IF sy-subrc <> 0.
      result = 0.
    ENDIF.

  ENDMETHOD.

  METHOD personalbest.

    DATA lt_list TYPE TABLE OF i.
    lt_list[] = scores_list[].
    SORT lt_list DESCENDING.
    READ TABLE lt_list INTO result INDEX 1.
    IF sy-subrc <> 0.
      result = 0.
    ENDIF.

  ENDMETHOD.

  METHOD personaltopthree.
    DATA lt_list TYPE TABLE OF i.
    lt_list[] = scores_list[].
    SORT lt_list DESCENDING.

    DATA(lv_iter) = lines( lt_list ).
    IF lv_iter > 3.
      lv_iter = 3.
    ENDIF.

    DATA(lv_idx) = 1.
    WHILE lv_idx <= lv_iter.
      READ TABLE lt_list INDEX lv_idx INTO DATA(lv_result).
      IF sy-subrc = 0.
        APPEND lv_result TO result.
      ENDIF.
      lv_idx = lv_idx + 1.
    ENDWHILE.

  ENDMETHOD.


ENDCLASS.

CLASS ltcl_high_scores DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS test_list_of_scores FOR TESTING RAISING cx_static_check.
    METHODS test_latest_score FOR TESTING RAISING cx_static_check.
    METHODS test_personal_best FOR TESTING RAISING cx_static_check.
    METHODS test_personal_top_three FOR TESTING RAISING cx_static_check.
    METHODS test_personal_highest_to_low FOR TESTING RAISING cx_static_check.
    METHODS test_personal_top_tie FOR TESTING RAISING cx_static_check.
    METHODS test_personal_top_less_3 FOR TESTING RAISING cx_static_check.
    METHODS test_personal_top_only_1 FOR TESTING RAISING cx_static_check.



ENDCLASS.

CLASS ltcl_high_scores IMPLEMENTATION.


  "List of scores
  METHOD test_list_of_scores.
    DATA(input_values) = VALUE zcl_high_scores=>integertab( ( 30 ) ( 50 ) ( 20 ) ( 70 ) ).
    DATA(cut) = NEW zcl_high_scores( input_values ).
    DATA(expected_values) = VALUE zcl_high_scores=>integertab( ( 30 ) ( 50 ) ( 20 ) ( 70 ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->list_scores( )
      exp = expected_values ).
  ENDMETHOD.

  "Latest score
  METHOD test_latest_score.
    DATA(input_values) = VALUE zcl_high_scores=>integertab( ( 100 ) ( 0 ) ( 90 ) ( 30 ) ).
    DATA(cut) = NEW zcl_high_scores( input_values ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->latest( )
      exp = 30 ).
  ENDMETHOD.


  "Personal best
  METHOD test_personal_best.
    DATA(input_values) = VALUE zcl_high_scores=>integertab( ( 40 ) ( 100 ) ( 70 ) ).
    DATA(cut) = NEW zcl_high_scores( input_values ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->personalbest( )
      exp = 100 ).
  ENDMETHOD.


  "Personal top three from a list of scores
  METHOD test_personal_top_three.
    DATA(input_values) = VALUE zcl_high_scores=>integertab( ( 10 ) ( 30 ) ( 90 ) ( 30 ) ( 100 ) ( 20 ) ( 10 )
                                                             ( 0 ) ( 30 ) ( 40 ) ( 40 ) ( 40 ) ( 70 ) ( 70 ) ).
    DATA(cut) = NEW zcl_high_scores( input_values ).
    DATA(expected_values) = VALUE zcl_high_scores=>integertab( ( 100 ) ( 90 ) ( 70 ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->personaltopthree( )
      exp = expected_values ).
  ENDMETHOD.


  "Personal top highest to lowest
  METHOD test_personal_highest_to_low.
    DATA(input_values) = VALUE zcl_high_scores=>integertab( ( 20 ) ( 10 ) ( 30 ) ).
    DATA(cut) = NEW zcl_high_scores( input_values ).
    DATA(expected_values) = VALUE zcl_high_scores=>integertab( ( 30 ) ( 20 ) ( 10 ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->personaltopthree( )
      exp = expected_values ).
  ENDMETHOD.


  "Personal top when there is a tie"
  METHOD test_personal_top_tie.
    DATA(input_values) = VALUE zcl_high_scores=>integertab( ( 40 ) ( 20 ) ( 40 ) ( 30 ) ).
    DATA(cut) = NEW zcl_high_scores( input_values ).
    DATA(expected_values) = VALUE zcl_high_scores=>integertab( ( 40 ) ( 40 ) ( 30 ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->personaltopthree( )
      exp = expected_values ).
  ENDMETHOD.


  "Personal top when there are less than 3
  METHOD test_personal_top_less_3.
    DATA(input_values) = VALUE zcl_high_scores=>integertab( ( 30 ) ( 70 ) ).
    DATA(cut) = NEW zcl_high_scores( input_values ).
    DATA(expected_values) = VALUE zcl_high_scores=>integertab( ( 70 ) ( 30 ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->personaltopthree( )
      exp = expected_values ).
  ENDMETHOD.

  "Personal top when there is only one
  METHOD test_personal_top_only_1.
    DATA(input_values) = VALUE zcl_high_scores=>integertab( ( 40 ) ).
    DATA(cut) = NEW zcl_high_scores( input_values ).
    DATA(expected_values) = VALUE zcl_high_scores=>integertab( ( 40 ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->personaltopthree( )
      exp = expected_values ).
  ENDMETHOD.


ENDCLASS.
