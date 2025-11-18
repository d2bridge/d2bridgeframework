{$IFNDEF D2Bridge_INC}
{$DEFINE D2Bridge_INC}
{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not sublicensed without
  express written authorization from the author (Talis Jonatas Gomes).
  This includes creating derivative works or distributing the source
  code through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

{-----------------------------------------------------
This file is divided into two parts: Configurations and Implementation
  * Settings: In this part there are options that can be activated or deactivated,
    thus changing the behavior of the DB2Bridge code.
    You can edit the "DEFINE" of this part to achieve the desired behavior.
  * Implementation: This part SHOULD NOT BE EDITED. Doing so may result in
    undefined behavior and difficult-to-diagnose problems.
-----------------------------------------------------}

(*//////////////// SETTINGS  ////////////////////*)

// To use the TMS Software Components, uncomment this line
// Component not implemented
//{$DEFINE TMSSOFTWARE_AVAILABLE}

// To use the Rx Library Components, uncomment this line
//{$DEFINE RXLIB_AVAILABLE}

// To use SMComponent Components, uncomment this line
//{$DEFINE SMCOMPONENTS_AVAILABLE}

// To use DevExpress Components, uncomment this line
//{$DEFINE DEVEXPRESS_AVAILABLE}

// To use JEDI (JVCL) Components, uncomment this line
//{$DEFINE JVCL_AVAILABLE}

// To use INFOPOWER Components, uncomment this line
//{$DEFINE INFOPOWER_AVAILABLE}

// To use VCL on Windows / Delphi, uncomment this line
{$DEFINE VCL}

// To use FMX (Firemonkey) Windows / Delphi uncomment this line
//{$DEFINE FMX}

(*//////////////// IMPLEMENTATION  ////////////////////*)

// Disables components according to the Framework
//------------------------------------------------------------------------------

{$IFDEF FPC}
  {$UNDEF TMSSOFTWARE_AVAILABLE}
  {$UNDEF RXLIB_AVAILABLE}
  {$UNDEF SMCOMPONENTS_AVAILABLE}
  {$UNDEF DEVEXPRESS_AVAILABLE}
  {$UNDEF JVCL_AVAILABLE}
  {$UNDEF INFOPOWER_AVAILABLE}
{$ENDIF}

{$IFDEF FMX}
  {$UNDEF TMSSOFTWARE_AVAILABLE}
  {$UNDEF RXLIB_AVAILABLE}
  {$UNDEF SMCOMPONENTS_AVAILABLE}
  {$UNDEF DEVEXPRESS_AVAILABLE}
  {$UNDEF JVCL_AVAILABLE}
  {$UNDEF INFOPOWER_AVAILABLE}
{$ENDIF}

// Set FreePascal to Delphi mode
//------------------------------------------------------------------------------
{$IFDEF FPC}
  {$DEFINE USE_UTF8}
  {$UNDEF BORLAND}
  {$DEFINE DFE_SEM_INDY}
  {$DEFINE VCL}
  {$DEFINE UNICODE} // Lazarus 0.9.26 uses UnicodeString as default for String
  {$DEFINE DELPHI7}
  {$DEFINE COMPILER7}
  {$DEFINE HAS_FORMATSETTINGS}
  {$DEFINE HAS_REGEXPR}
  {$DEFINE HAS_INLINE}
  {$DEFINE HAS_STRICTDELIMITER}
  {$INTERFACES COM}
  {$H+}

  {$UnDef FMX}
  {$UnDef FPC3}
  {$UnDef FPC2}
  {$IFDEF VER2}
   {$DEFINE FPC2}
  {$EndIf}
  {$IFDEF VER3}
   {$DEFINE FPC3}
  {$ENDIF}
  {$IFDEF FPC3}
   {$DEFINE HAS_CHARINSET}
   {$DEFINE SUPPORTS_DEPRECATED_DETAILS}
   {$UnDef FPC2}
  {$ENDIF}
  {$UNDEF REMOVE_CAST_WARN} //Due to issues with the error message "Message recording not yet supported"
{$ELSE}
  {$DEFINE BORLAND}
{$ENDIF}

// use to facilitate the maintenance of D2Bridge.inc, since it was a copy
// from jedi, this change allows for better file evolution.
//------------------------------------------------------------------------------
{$I D2Bridge_jedi.inc}

{$IFNDEF DELPHIXE2_UP}
  {$IFDEF BORLAND}
    {$UNDEF REMOVE_CAST_WARN}
  {$ENDIF}
{$ENDIF}

{$IFDEF REMOVE_CAST_WARN}
  {$WARN IMPLICIT_STRING_CAST OFF}
  {$WARN IMPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {.$WARN SYMBOL_DEPRECATED OFF}
  {$IFDEF BORLAND}
    {$WARN DUPLICATE_CTOR_DTOR OFF}
    {$WARN CVT_ACHAR_TO_WCHAR OFF}
  {$ENDIF}
{$ENDIF}

{$IFNDEF MSWINDOWS}   // Linux, only OpenSSL, no Capicom
  {$DEFINE DFE_SEM_CAPICOM}
  {$DEFINE DFE_SEM_MSXML}
  {$DEFINE DFE_SEM_INDY}
  {$UnDef STDCALL}
{$ENDIF}

{$IFDEF DFE_SEM_OPENSSL}
  {$DEFINE DFE_SEM_XMLSEC}
  {$DEFINE DFE_SEM_LIBXML2}
{$ENDIF}

{$IFNDEF SUPPORTS_DELAYED_LOADING}
 {$UNDEF USE_DELAYED}
{$ENDIF}

{$IFDEF DELPHI2005_UP}
  {$DEFINE HAS_INLINE}
{$ENDIF}
{$IFDEF DELPHI2006_UP}
  {$DEFINE HAS_STRICTDELIMITER}
{$ENDIF}
{$IFDEF DELPHI2009_UP}
  {$DEFINE HAS_CHARINSET}
  {$DEFINE USE_JSONDATAOBJECTS_UNIT}
  {$DEFINE SUPPORTS_FTEXTENDED}
{$ENDIF}
{$IFDEF DELPHI2010_UP}
  {$DEFINE SUPPORTS_FUNCTION_REFERENCES}
  {$DEFINE SUPPORTS_ANONYMOUS_FUNCTIONS}
  {$DEFINE HAS_RTTI_FIELD}
{$ENDIF}
{$IFDEF DELPHIXE_UP}
  {$DEFINE HAS_FORMATSETTINGS}
  {$DEFINE HAS_REGEXPR}
{$ENDIF}
{$IFDEF DELPHIXE2_UP}
  {$DEFINE HAS_UNIT_SYSTEM_IOUTILS}
{$ENDIF}
{$IFDEF DELPHIXE6_UP}
  {$DEFINE HAS_UNIT_SYSTEM_JSON}
{$ENDIF}
{$IFDEF DELPHIXE7_UP}
  {$DEFINE HAS_UNIT_SYSTEM_THREADING}
  {$DEFINE HAS_UNIT_SYSTEM_NETENCODING}
{$ENDIF}
{$IfDEF DELPHIXE8_UP}
  {$DEFINE HAS_BLUETOOTH}
  {$DEFINE HAS_SYSTEM_GENERICS}
{$ENDIF}

{$IFDEF FPC}
  {$IF DEFINED(FPC_FULLVERSION)}
    {$IF defined(FPC_FULLVERSION) and (FPC_FULLVERSION >= 30301)}
      {$DEFINE SUPPORTS_FUNCTION_REFERENCES}
      {$DEFINE SUPPORTS_ANONYMOUS_FUNCTIONS}
      {$DEFINE SUPPORTS_FTEXTENDED}

      {$DEFINE HAS_UNIT_SYSTEM_THREADING}
      {$DEFINE HAS_RTTI_FIELD}
    {$IFEND}
  {$IFEND}
{$ENDIF}

// Cross-platform settings
//------------------------------------------------------------------------------
{$IFDEF WIN64}
  {$DEFINE MSWINDOWS}
  {$DEFINE DFE_SEM_CAPICOM}  // 32-bit only
  {$DEFINE DFE_SEM_MSXML}    // 32-bit only
{$ENDIF}

{$IFDEF DELPHILANGUAGE}
  {$IFDEF POSIX}
    {$IFDEF LINUX}
      {$DEFINE USE_UTF8}
      {$UNDEF HAS_BLUETOOTH}
    {$ENDIF}
    {$DEFINE FMX}
    {$DEFINE HAS_SYSTEM_GENERICS}

    {$UNDEF CLX}
    {$UNDEF VisualCLX}
    {$UNDEF VCL}
    {$DEFINE DFE_SEM_CAPICOM}
    {$DEFINE DFE_SEM_MSXML}
    {$UNDEF USE_DELAYED}
    {$LEGACYIFEND ON}
  {$ENDIF}

  {$IFDEF NEXTGEN}
    {$DEFINE HAS_SYSTEM_GENERICS}
    {$DEFINE USE_UTF8}
    {$DEFINE HAS_BLUETOOTH}
    {$LEGACYIFEND ON}
    {$ZEROBASEDSTRINGS OFF}  //http://riversoftavg.com/blogs/index.php/2015/01/17/zerobasedstrings-just-dont/
  {$ENDIF}

  {$IFDEF CLX}
    {$DEFINE VisualCLX}
  {$ENDIF}

  {$IFDEF CONDITIONALEXPRESSIONS}
    {$IF Declared(QEventType_CMQuit) or Declared(Key_Word_Lower)}
        {$DEFINE VisualCLX}
    {$IFEND}
  {$ENDIF}

  {$IFNDEF VisualCLX}
    {$DEFINE VCL}
  {$ENDIF}

  {$IFDEF VisualCLX}
    {$UNDEF VCL}
    {$DEFINE COMPLIB_CLX} // kept for backward compatibility, use VisualCLX instead
  {$ENDIF}

  {$IFDEF QUnit}
    {$UNDEF VCL}
    {$DEFINE VisualCLX}
  {$ENDIF}

  {$IFDEF FMX}
    {$UNDEF VCL}
  {$ENDIF}

  {$IFDEF VCL}
    {$DEFINE COMPLIB_VCL} // kept for backward compatibility, use VCL instead
  {$ENDIF}

  {$IFDEF VisualCLX}
    {$DEFINE DELPHI6_UP} // Added to support D5 and maintain compatibility with CLX
  {$ENDIF}
{$ENDIF DELPHILANGUAGE}

//------------------------------------------------------------------------------
// Automatic definitions for license types:
//------------------------------------------------------------------------------
{$IFDEF D5Standard}
 {$DEFINE DelphiPersonalEdition}
{$ENDIF}

{$IFDEF D6PersonalEdition}
 {$DEFINE DelphiPersonalEdition}
{$ENDIF}

{$IFDEF D7PersonalEdition}
 {$DEFINE DelphiPersonalEdition}
{$ENDIF}

// Reduces warnings in D7:
//------------------------------------------------------------------------------
{$IFDEF COMPILER7_UP}
  {$IFNDEF FPC}
    {$WARN UNSAFE_TYPE OFF}
    {$WARN UNSAFE_CODE OFF}
    {$WARN UNSAFE_CAST OFF}
  {$ENDIF}
{$ENDIF}

// Checking if compilation should be in text mode "NOGUI"
// Note: FPC on Linux always turns on the "CONSOLE" directive, that's why we created NOGUI
{$IFDEF FRAMEWORK}
  {$DEFINE NOGUI}
{$ENDIF}

//  Lazarus Android with LAMW, does not support Dialogs, Forms,
{$IFDEF LAMW}
  {$DEFINE NOGUI}
{$ENDIF}

{$IFDEF NOGUI}
  {$DEFINE CONSOLE}
{$ENDIF}

// Enable the below directive to use compiled Libxml2, libxslt, libxmlsec
// with MinGw ftp://ftp.zlatkovic.com/libxml/64bit/
//{$DEFINE USE_MINGW}

// ZLib in D7 contains many bugs and does not support GZip properly
{$IfNDef FPC}
 {$IfNDef DELPHIXE2_UP}
  {$Define USE_ZLibExGZ}
 {$EndIf}
{$Else}
 {$UnDef USE_ZLibExGZ} // ZLibExGZ is not FPC compatible
{$EndIf}

// From version XE2 you need to use namespaces, if not defined "Unit scope names"
{$IFNDEF FPC}
  {$IFDEF DELPHIXE2_UP}
    {$DEFINE USE_NAMESPACES}
  {$ENDIF}
{$ENDIF}


{$ENDIF ~D2Bridge_INC}
