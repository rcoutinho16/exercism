*&---------------------------------------------------------------------*
*& Report Z_KINDERGARTEN_GARDEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_kindergarten_garden.

CLASS zcl_kindergarten_garden DEFINITION.

  PUBLIC SECTION.
    METHODS plants
      IMPORTING
        diagram        TYPE string
        student        TYPE string
      RETURNING
        VALUE(results) TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_plant
      IMPORTING
        iv_letter     TYPE c
      RETURNING
        VALUE(result) TYPE string.

    DATA students TYPE string_table.

ENDCLASS.


CLASS zcl_kindergarten_garden IMPLEMENTATION.

  METHOD plants.

    DATA: lt_diag   TYPE TABLE OF string,
          ls_diag1  TYPE string,
          ls_diag2  TYPE string,
          lv_name   TYPE string VALUE 'ABCDEFGHIJKL',
          lv_letter TYPE c,
          lv_idx    TYPE i.


    SPLIT diagram AT '\n' INTO TABLE lt_diag.
    FIND student(1) IN lv_name MATCH OFFSET lv_idx.
    lv_idx = lv_idx * 2.

    READ TABLE lt_diag INTO ls_diag1 INDEX 1.
    READ TABLE lt_diag INTO ls_diag2 INDEX 2.

    lv_letter = ls_diag1+lv_idx(1).
    APPEND me->get_plant( lv_letter ) TO results.
    lv_idx = lv_idx + 1.
    lv_letter = ls_diag1+lv_idx(1).
    APPEND me->get_plant( lv_letter ) TO results.
    lv_idx = lv_idx - 1.
    lv_letter = ls_diag2+lv_idx(1).
    APPEND me->get_plant( lv_letter ) TO results.
    lv_idx = lv_idx + 1.
    lv_letter = ls_diag2+lv_idx(1).
    APPEND me->get_plant( lv_letter ) TO results.

  ENDMETHOD.

  METHOD get_plant.

    CASE iv_letter.
      WHEN 'V'.
        result = 'violets'.
      WHEN 'R'.
        result = 'radishes'.
      WHEN 'G'.
        result = 'grass'.
      WHEN 'C'.
        result = 'clover'.
      WHEN OTHERS.
        result = ''.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_kindergarten_garden DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_kindergarten_garden.
    METHODS setup.
    METHODS test_garden_single_student FOR TESTING RAISING cx_static_check.
    METHODS test_garden_single_student2 FOR TESTING RAISING cx_static_check.
    METHODS test_garden_two_students FOR TESTING RAISING cx_static_check.
    METHODS test_garden_two_students2 FOR TESTING RAISING cx_static_check.
    METHODS test_garden_third_students FOR TESTING RAISING cx_static_check.
    METHODS test_alice FOR TESTING RAISING cx_static_check.
    METHODS test_bob FOR TESTING RAISING cx_static_check.
    METHODS test_charlie FOR TESTING RAISING cx_static_check.
    METHODS test_david FOR TESTING RAISING cx_static_check.
    METHODS test_eve FOR TESTING RAISING cx_static_check.
    METHODS test_fred FOR TESTING RAISING cx_static_check.
    METHODS test_ginny FOR TESTING RAISING cx_static_check.
    METHODS test_harriet FOR TESTING RAISING cx_static_check.
    METHODS test_ileana FOR TESTING RAISING cx_static_check.
    METHODS test_joseph FOR TESTING RAISING cx_static_check.
    METHODS test_kincaid FOR TESTING RAISING cx_static_check.
    METHODS test_larry FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_kindergarten_garden IMPLEMENTATION.

  METHOD setup.
    cut = NEW zcl_kindergarten_garden( ).
  ENDMETHOD.

  "garden with single student
  METHOD test_garden_single_student.
    DATA(expected_values) = VALUE string_table( ( |radishes| ) ( |clover| ) ( |grass| ) ( |grass| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'RC\nGG' student = 'Alice' )
      exp = expected_values ).
  ENDMETHOD.

  "different garden with single student
  METHOD test_garden_single_student2.
    DATA(expected_values) = VALUE string_table( ( |violets| ) ( |clover| ) ( |radishes| ) ( |clover| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VC\nRC' student = 'Alice' )
      exp = expected_values ).
  ENDMETHOD.

  "garden with two students
  METHOD test_garden_two_students.
    DATA(expected_values) = VALUE string_table( ( |clover| ) ( |grass| ) ( |radishes| ) ( |clover| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VVCG\nVVRC' student = 'Bob' )
      exp = expected_values ).
  ENDMETHOD.

  "second student's garden
  METHOD test_garden_two_students2.
    DATA(expected_values) = VALUE string_table( ( |clover| ) ( |clover| ) ( |clover| ) ( |clover| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VVCCGG\nVVCCGG' student = 'Bob' )
      exp = expected_values ).
  ENDMETHOD.

  "third student's garden
  METHOD test_garden_third_students.
    DATA(expected_values) = VALUE string_table( ( |grass| ) ( |grass| ) ( |grass| ) ( |grass| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VVCCGG\nVVCCGG' student = 'Charlie' )
      exp = expected_values ).
  ENDMETHOD.

  "for Alice, first student's garden
  METHOD test_alice.
    DATA(expected_values) = VALUE string_table( ( |violets| ) ( |radishes| ) ( |violets| ) ( |radishes| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV' student = 'Alice' )
      exp = expected_values ).
  ENDMETHOD.

  "for Bob, second student's garden
  METHOD test_bob.
    DATA(expected_values) = VALUE string_table( ( |clover| ) ( |grass| ) ( |clover| ) ( |clover| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV' student = 'Bob' )
      exp = expected_values ).
  ENDMETHOD.

  "for Charlie
  METHOD test_charlie.
    DATA(expected_values) = VALUE string_table( ( |violets| ) ( |violets| ) ( |clover| ) ( |grass| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV' student = 'Charlie' )
      exp = expected_values ).
  ENDMETHOD.

  "for David
  METHOD test_david.
    DATA(expected_values) = VALUE string_table( ( |radishes| ) ( |violets| ) ( |clover| ) ( |radishes| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV' student = 'David' )
      exp = expected_values ).
  ENDMETHOD.

  "for Eve
  METHOD test_eve.
    DATA(expected_values) = VALUE string_table( ( |clover| ) ( |grass| ) ( |radishes| ) ( |grass| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGC' student = 'Eve' )
      exp = expected_values ).
  ENDMETHOD.

  "for Fred
  METHOD test_fred.
    DATA(expected_values) = VALUE string_table( ( |grass| ) ( |clover| ) ( |violets| ) ( |clover| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV' student = 'Fred' )
      exp = expected_values ).
  ENDMETHOD.

  "for Ginny
  METHOD test_ginny.
    DATA(expected_values) = VALUE string_table( ( |clover| ) ( |grass| ) ( |grass| ) ( |clover| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV' student = 'Ginny' )
      exp = expected_values ).
  ENDMETHOD.

  "for Harriet
  METHOD test_harriet.
    DATA(expected_values) = VALUE string_table( ( |violets| ) ( |radishes| ) ( |radishes| ) ( |violets| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV' student = 'Harriet' )
      exp = expected_values ).
  ENDMETHOD.

  "for Ileana
  METHOD test_ileana.
    DATA(expected_values) = VALUE string_table( ( |grass| ) ( |clover| ) ( |violets| ) ( |clover| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV' student = 'Ileana' )
      exp = expected_values ).
  ENDMETHOD.

  "for Joseph
  METHOD test_joseph.
    DATA(expected_values) = VALUE string_table( ( |violets| ) ( |clover| ) ( |violets| ) ( |grass| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV' student = 'Joseph' )
      exp = expected_values ).
  ENDMETHOD.

  "for Kincaid
  METHOD test_kincaid.
    DATA(expected_values) = VALUE string_table( ( |grass| ) ( |clover| ) ( |clover| ) ( |grass| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV' student = 'Kincaid' )
      exp = expected_values ).
  ENDMETHOD.

  "garden with single student
  METHOD test_larry.
    DATA(expected_values) = VALUE string_table( ( |grass| ) ( |violets| ) ( |clover| ) ( |violets| ) ).
    cl_abap_unit_assert=>assert_equals(
      act = cut->plants( diagram = 'VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV' student = 'Larry' )
      exp = expected_values ).
  ENDMETHOD.


ENDCLASS.
