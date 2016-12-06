/* hack for default styles */
body {
	overflow: hidden;
}
table.outerNoSidebar {
	padding-bottom: 0 !important;
}
td.noSidebarCell {
	padding: 0;
}
.labelText {
	list-style: none;
	color: #4A4A56;
	font-weight: 700;
}
.labelTextBlock {
	display: block;
	list-style: none;
	color: #4A4A56;
	font-weight: 700;
}
.inputFieldStd, .inputFieldStdDisabled {
	width: 89.5%;
}
.inputFieldExt {
	width: 91%;
}
.inputFieldAddress {
	width: 35%;
	min-width: 276px;
}
.textAreaDesc {
	width: 100%;
	height: 200px;
}
.checkboxLabelText {
	color: #4A4A56;
	font-weight: 700;
}
#form {
	/*width: 67%;
	float: left;*/
}
div.bPageBlock {
	padding: 0px !important;
	margin: 0px !important;
	border-bottom: 2px solid #3887A8 !important;
	border-top: none !important;
	border-radius: 2px !important;
}
div.pbBottomButtons td.pbTitle {
	width: 10% !important;
}
div#presence_widget {
	right: 300px !important;
}
div.pbHeader table td.pbTitle {
	width:90%;
}
.multiselect select {
	width: 100px !important;
}
div.recipientsBlock input.inputDateField {
	display: block;
	margin: 0 auto;
}
.noselect {
	-webkit-touch-callout: none;
	-webkit-user-select: none;
	-khtml-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
}

/* header */
div.header {
	width: 100%;
	font-family: tahoma, arial, sans-serif;
	font-size: 12px;
	position: relative;
	-webkit-box-shadow: 0 4px 4px -2px #888;
	/*-moz-box-shadow: 0 4px 4px -2px #888;*/
	box-shadow: 0 4px 4px -2px #888;
	z-index: 1;
}
div.innerpadding {
	padding: 10px;
	height: 50px;
	background-color: #EEE;
	/*-webkit-border-top-left-radius: 5pt;
	-webkit-border-top-right-radius: 5pt;
	-moz-border-radius-topleft: 5pt;
	-moz-border-radius-topright: 5pt;
	border-top-left-radius: 5pt;
	border-top-right-radius: 5pt;*/
	border-bottom: 2px solid #AAA;
}
div.step, div.stepDisabled, div.completenessholder {
	height: 100%;
	/*float:left;*/
	position: relative;
	/*-moz-border-radius: 5pt;*/
	-webkit-border-radius: 5pt;
	border-radius: 5pt;
	background-color: #888;
	color: #FFF;
	text-align: center;
	font-weight: bold;
	display: table;
	cursor: default;
}
div.stepHolder {
	width: 20%;
	height: 100%;
	float: left;
}
div.stepDisabled {
	background-color: #666;
	color: #CCC;
	cursor: no-drop;
	width: 100%;
}
div.stepDisabled:hover {
	background-color: #555;
	color: #BBBBBB;
}
div.stepDisabled:active {
	background-color: #555;
	color: #B6B6B6;
}
div.step {
	cursor: pointer;
	width: 100%;
}
div.step:hover {
	background-color: #A0A0A0;
}
div.step:active {
	background-color: #A8A8A8;
}
div.blue {
	background-color: #69B3D6;
	cursor: default;
}
div.blue:hover {
	background-color: #69B3D6;
}
div.downarrow, div.nodownarrow {
	width: 100%;
	text-align: center;
	display: table-cell;
	vertical-align: middle;
	padding: 0px 5px;
}
.downarrow:before {
	content: "";
	position: absolute;
	border-left: 24px solid rgba(113, 101, 58, 0);
	border-right: 24px solid rgba(113, 101, 58, 0);
	border-top: 24px solid #69B3D6;
	display: inline-block;
	bottom: -24px;
}
div.blankspace {
	width: 6%;
	height: 100%;
	float: left;
	position: relative;
	padding: 0px;
	text-align: center;
	display: table;
}
div.arrowholder {
	display: table-cell;
	vertical-align: middle;
}
div.rightarrow {
	text-align: center;
	display: inline-block;
}
.rightarrow:before {
	content: "";
	position: relative;
	border-top: 15px solid rgba(113, 101, 58, 0);
	border-bottom: 15px solid rgba(113, 101, 58, 0);
	border-left: 10px solid #000;
	display: inline-block;
}
div.completenessholder {
	width: 100%;
	background-color: #DDD;
	color: #000;
}
div.completenesscenter {
	text-align: left;
	display: table-cell;
	vertical-align: middle;
	padding-left: 10px;
	padding-right: 10px;
}
div.completenesstext {
	width: 100%;
}
div.percentageholder {
	width: 100%;
	margin-top: 2px;
}
div.percentagebg, div.percentage {
	width: 100%;
	height: 21px;
	/*-moz-border-radius: 5pt;*/
	-webkit-border-radius: 5pt;
	border-radius: 5pt;
}
div.percentagebg {
	/*-moz-box-shadow: inset 0 0 8px #000;*/
	-webkit-box-shadow: inset 0 0 8px #000;
	box-shadow: inset 0 0 8px #000;
}
div.percentage {
	min-width: 30px;
	background-color: #000;
}
div.percentagetextholder {
	height: 100%;
	display: table;
	padding-left: 3px;
}
div.percentagetext{
	color: #FFF;
	display: table-cell;
	vertical-align: middle;
}

/* footer */
div.footer {
	width: 100%;
	font-family: tahoma, arial, sans-serif;
	font-size: 12px;
	position: relative;
	float: left;
	-webkit-box-shadow: 0 -4px 4px -2px #888;
	/*-moz-box-shadow: 0 -4px 4px -2px #888;*/
	box-shadow: 0 -4px 4px -2px #888;
	z-index: 1;
}
div.footerInnerPadding {
	padding: 10px 10px 10px 10px;
	height: 44px;
	background-color: #EEEEEE;
	-webkit-border-bottom-left-radius: 5pt;
	-webkit-border-bottom-right-radius: 5pt;
	/*-moz-border-radius-bottomleft: 5pt;*/
	/*-moz-border-radius-bottomright: 5pt;*/
	border-bottom-left-radius: 5pt;
	border-bottom-right-radius: 5pt;
	border-top: 2px solid #BBBBBB;
}
div.footerTextPadding {
	padding-bottom: 2px;
}
div.footerButtonRight, div.footerButtonLeft {
	font-weight: bold;
}
div.footerButtonRight {
	float: right;
}
div.footerButtonLeft {
	float: left;
}

/* notes */
div.rightInfoPanelHolder{
	float: left;
	width: 33%;
	background-color: #FFFFFF;
}
div.rightInfoPanel{
	padding: 0px;
	height: 100%;
}
div.rightInfoNoteHolder{
	display: table;
	height: 100%;
	width: 100%;
}
div.rightInfoNote {
	display: table-cell;
	overflow: auto;
	height: 100%;
	background-color: #EEEEEE;
	position: relative;
}
div.rightInfoNoteHeader {
	background-color: #EEEEEE;
	font-weight: bold;
	width:100%;
	display: table;
}
div.rightInfoNoteButtonsHolder {
	display: table;
	width: 100%;
}
div.rightInfoNoteButtons, div.rightInfoNoteButtonsSelected {
	height:32px;
	width: 20%;
	cursor: pointer;
	text-align: center;
	display: table-cell;
	vertical-align: middle;
}
div.rightInfoNoteButtons {
	border-right: 1px solid #BBBBBB;
	border-bottom: 1px solid #BBBBBB;
	color: #666666;
	background: #CCCCCC;
}
div.rightInfoNoteButtons:last-child {
	border-right: none;
}
div.rightInfoNoteButtons:hover {
	background: #D4D4D4;
}
div.rightInfoNoteButtons:active {
	background: #DDDDDD;
}
div.rightInfoNoteButtonsSelected {
	border-bottom: none;
	padding-bottom: 1px;
	color: #000000;
	background: #EEEEEE;
}
div.rightInfoNoteButtonsSelected:hover {
	background: #EEEEEE;
	cursor: default;
}
div.rightInfoNoteButtonsSelected:active {
	background: #E6E6E6;
	cursor: default;
}
div.rightInfoNoteFooterHolder {
	font-weight: bold;
	text-align: center;
	cursor: pointer;
	display: table;
	width: 100%;
}
div.rightInfoNoteFooter {
	display: table;
	width: 100%;
}
div.rightInfoNoteFooter a {
	display: table-cell;
	text-decoration: none;
}
div.rightInfoNoteFooterIndex {
	color: #000;
	display: table-cell;
	cursor: default;
}
div.rightInfoCurrentNoteHolder {
	border: 1px solid #BBBBBB;
	margin: 5px;
}
div.rightInfoCurrentNoteHolder textarea {
	width:100%;
	height:100%;
	padding: 0px;
	margin: 0px;
	border: none;
	resize: none;
}

/* mainStyle */
.bEditBlock {
	border-radius: 0px !important;
}
.mainStyle div div div div {
	border: none;
}
.mainStyle div div div div.pbBody div div {
	margin-top: 2px;
	margin-bottom: 2px;
}
.mainStyle div.pbHeader table  {
	padding: 0px 0px 0px 0px !important;
	background-color: #E4ECF2;
}
.mainStyle div div div div.pbHeader table tbody tr td {
	padding-top: 8px;
	padding-bottom: 8px;
	width: 95%;
}
.mainStyle div.message {
	/*-moz-border-radius: 4px;*/
	-webkit-border-radius: 4px;
	border-radius: 4px;
	background-color: #FFC;
	border-style: solid;
	border-width: 1px;
	color: #000;
	padding: 6px 8px 6px 6px;
	margin: 4px 20px;
}
td.dataCol.dataCell {
	width: 45%;
	padding-top: 0px !important;
}
td.splitter {
	width: 10%;
}

/* hack for pagemessages */
.mainStyle div.errorM6, .mainStyle div.errorM4, .mainStyle div.errorM3, .mainStyle div.errorM2, .mainStyle div.errorS1 {
	border-color: #C00;
}
.mainStyle div.messageText {
	background-color: #FFC;
	margin-left: 8px;
	border-bottom: none;
}
.cke_skin_sfdc {
	border: none !important;
}

/* buttons */
table#bodyTable input[type=submit], table#bodyTable input[type=button], input[type=button].milroseBtnStyle, input[type=submit].milroseBtnStyle, a.milroseBtnStyle {
	border: 1px solid #3887A8 !important;
	background: #F4F6F9 !important;
	/*-moz-border-radius: 0px !important;*/
	-webkit-border-radius: 0px !important;
	 border-radius: 0px !important;
	padding-left: 8px !important;
	padding-right: 8px !important;
	margin-left: 3px !important;
	margin-right: 0px !important;
}
table#bodyTable input[type=submit].btnDisabled, table#bodyTable input[type=button].btnDisabled, input[type=button].milroseBtnStyle.btnDisabled, input[type=submit].milroseBtnStyle.btnDisabled, a.milroseBtnStyle.btnDisabled {
	border: 1px solid #BBBBBB !important;
	background-color: #DDDDDD !important;
	color: #888888 !important;
}
table#bodyTable input[type=submit]:hover, table#bodyTable input[type=button]:hover, input[type=button].milroseBtnStyle:hover, input[type=submit].milroseBtnStyle:hover, a.milroseBtnStyle:hover {
	background: #69B3D6 !important;
	color: #FFFFFF !important;
}
table#bodyTable input[type=submit]:active, table#bodyTable input[type=button]:active, input[type=button].milroseBtnStyle:active, input[type=submit].milroseBtnStyle:active, a.milroseBtnStyle:active {
	background: #5FA2C2 !important;
	color: #FFFFFF !important;
}
table#bodyTable input[type=submit].btnDisabled:hover, table#bodyTable input[type=button].btnDisabled:hover, input[type=button].milroseBtnStyle.btnDisabled:hover, input[type=submit].milroseBtnStyle.btnDisabled:hover, a.milroseBtnStyle.btnDisabled:hover {
	background: #D4D4D4 !important;
	color: #808080 !important;
}
table#bodyTable input[type=submit].btnDisabled:active, table#bodyTable input[type=button].btnDisabled:active, input[type=button].milroseBtnStyle.btnDisabled:active, input[type=submit].milroseBtnStyle.btnDisabled:active, a.milroseBtnStyle.btnDisabled:active {
	background: #CACACA !important;
	color: #808080 !important;
}

/* inline table hack */
table.inlineTableLeft {
	width: 100%;
	float: left;
}
table.inlineTableRight {
	width: 100%;
	float: left;
}
table.inlineTableLeft tr td {
	vertical-align: middle;
}
.labelTextInline {
	list-style: none;
	color: #4A4A56;
	font-weight: bold;
}
.valueTextInline {
	width: 100%;
}

/* required blocks */
.requiredBlockWrapper {
	position: relative;
}
.requiredBlockMarker {
	background-color: #C00 !important;
	position: absolute;
	left: -6px;
	width: 3px;
	top: 0px;
	height: 20px;
	margin-top: 0px !important;
	margin-bottom: 0px !important;
}
@-moz-document url-prefix() {
	.requiredBlockMarker{
		background-color: #c00 !important;
		position: absolute;
		left: -6px;
		width: 3px;
		top: -2px;
		height: 20px;
		margin-top: 0px !important;
		margin-bottom: 0px !important;
	}
}
.required > div {
	display: inline-table;
	text-align: center;
}
.required > div > div {
	display: table-cell;
}
.required > div > div:first-child {
	padding-right: 2px;
	border-left: 3px solid #C00;
}

/* service items blocks */
span.sowOtherQuestions div div div div div div.pbBody div div table.detailList td table {
	width:100%;
}
table.generalTableStyle {
	width: 100%;
	border: 2px solid #3887A8;
	border-collapse: collapse;
	margin-bottom: 10px;
}
table.generalTableStyle th, table.generalTableStyle td.header {
	background-color: #E0F0F9;
	color: #000000;
	font-weight: bold;
	text-align: center;
	border: 1px solid #AED4E4;
	padding: 2px;
}
table.generalTableStyle th {
	cursor: default;
}
table.generalTableStyle td {
	border: 1px solid #AED4E4;
	padding: 2px;
}
table.generalTableStyle tr td.footer {
	text-align: right;
	font-weight: bold;
	background-color: #E0F0F9;
	color: #000000;
}
table.generalTableStyle tr td.name {
	text-align: left;
}
table.generalTableStyle td.data {
	text-align: center;
}
table.generalTableStyle td.left {
	border-right: 0px;
}
table.generalTableStyle td.right {
	border-left: 0px;
}
table.generalTableStyle td.bold {
	font-weight: bold;
}
.rowDnD {
	background-color: #E0F0F9;
}
.tableInput {
	text-align: center;
	padding: 0px;
	margin: 0px;
	border: 1px solid #CCC;
}
table.generalTableStyle td.pending {
	color: #FF6A00;
	font-weight: bold;
}
table.generalTableStyle td.editablePhase:hover {
	background-color: #E0F0F9;
	cursor: pointer;
}
table.generalTableStyle td.editableFloor:hover {
	background-color: #E0F0F9;
	cursor: pointer;
}

/* multi-select picklist */
table.detailList tr.multiSelectPicklistRow td select {
	height: 100px;
}

/* input date fields with pickers */
span.dateFormat {
	padding-top: 3px;
}

/* billing preferences picklists */
.inlineTableLeft tr td div {
	display: table !important;
	width: 100% !important;
	margin: 0px !important;
}
.inlineTableLeft tr td div div {
	/*overflow: hidden !important;*/
	display: table-cell !important;
	vertical-align: middle !important;
	min-width: 100px !important;
	width: 100px !important;
}
.inlineTableLeft tr td div select {
	/*display: table-cell !important;*/
	/*float: left !important;*/
	/*vertical-align: middle !important;*/
}

/* help tooltip */
.helpOrb{
	display:inline;
	top: 0;
}
.helpTooltip, .helpTooltipTop{
	text-decoration: none;
	position: absolute;
	display: none;
	width: 15em;
	z-index: 120;
	background-color: #fefdb9 !important;
	padding: 2px 5px;
	border: 1px solid orange !important;
	border-bottom: 1px solid #EE6000 !important;
	border-right: 1px solid #EE6000 !important;
	text-align: left;
	white-space: normal;
	font-weight: normal;
	color: #000;
	box-shadow: 2px 2px 4px 0px rgba(0,0,0,0.4);
}
.helpTooltipTop {
	top: 1em;
}

/* overlay */
.overlay {
	width: 100%;
	height: 100%;
	position: absolute;
	text-align: center;
	z-index: 90;
	padding: 0;
	margin: 0;
	display: none;
	background-color: #F7FAFF;
	font-family: Arial;
	font-size: 24px;
	color: #000077;
	opacity:0.8;
}
.overlayContent{
	position: absolute;
	top: 50%;
	left: 40%;
}
.purchaseOrderMainTable .labelCol {
	width: 30% !important;
}
.generalTableStyle .message td {
	border: none !important;
}
#purchaseOrderServicesTableJQ thead tr th.header {
  background-position: 0% 50%;
}
.changeHistoryTable{
	width:100%;
	padding: 0px;
	margin: 0px;
	border-collapse: collapse;
	border: none;
}
.changeHistoryNoteHolder{
	background-color: #EEEEEE;
}

/* accordion */
.ui-accordion-header {
	display: table;
	position: relative;
	margin-top: 0px;
	padding: 2px 0px 0px 0px;
	min-height: 0; /* support: IE7 */
}
.ui-accordion > span.ui-state-default td, .ui-accordion > span.ui-state-active td {
	font-weight: bold;
	background-color: #3887A8;
	color: #FFF;
}
.ui-accordion > span .ui-state-default {
	cursor: pointer;
}
.ui-accordion > span.ui-state-active {
	cursor: default;
}
.accordionImage {
	background-repeat: no-repeat;
	background-position: center;
	display:block;
	width: 10px;
	height: 10px;
}
.ui-state-default .accordionImage {
	background-image:url("/img/setup_plus.gif");
}
.ui-state-active .accordionImage {
	background-image:url("/img/setup_minus.gif");
}
.ui-state-active td {
	background-color: #58A7C8 !important;
}
.ui-accordion > span.ui-state-hover > table {
	cursor: pointer !important;
	background-color: #58A7C8 !important;
}
.ui-accordion-content-active {
	margin: 0px !important;
}
.ui-accordion-content-active > table:first-child {
	border-top: none;
}
.ui-state-default {
	border: none;
	font-weight: bold;
	color: #555555;
}
.tableContainer {
	width: 100%;
	margin: 0px;
	overflow: auto;
}
.floatingStyle {
	position:relative;
	background:#F2F3F3;
}
		
/* other / IDK */
.overlay {
	width: 100%;
	height: 100%;
	position: absolute;
	text-align: center;
	z-index: 90;
	padding: 0;
	margin: 0;
	display: none;
	background-color: #F7FAFF;
	font-family: Arial;
	font-size: 24px;
	color: #000077;
	opacity:0.8;
}
.overlayContent{
	position: absolute;
	top: 50%;
	left: 40%;
}
.purchaseOrderMainTable .labelCol {
	width: 30% !important;
}
.changeHistoryTable{
	width:100%;
	padding: 0px;
	margin: 0px;
	border-collapse: collapse;
	border: none;
}
.changeHistoryNoteHolder{
	background-color: #EEEEEE;
}
#foundServicesesTable tr:hover{
	background-color: #DDD;
}
div.internalReviewerPanel div.inputFieldStd select {
	display: none;
}

/*select service work type */
.serviceSelectBlock select {
	width: 100% !important;
}
.typeInWorkType table {
	width: 100%;
}

/* popup dialogs */
div.popupDialog > div.modalBackground {
	z-index: 40;
	opacity: 0.7;
	filter:alpha(opacity=70);
	position: absolute;
	top: 0px;
	left: 0px;
	width: 100%;
	height: 100%;
	background-color: #8AC;
}

div.popupDialog > div.modalForeground {
	z-index: 41;
	position: absolute;
	top: 0px;
	left: 0px;
	width: 100%;
	height: 100%;
	background-color: transparent;
}

div.popupDialog > div > div {
	width: 500px;
	position: relative;
	left: 0;
	right: 0;
	top: 20%;
	border: 1px solid #888;
	background-color: #F0F8FF;
	box-shadow: 5px 5px 25px #115577;
	margin: 0 auto;
}
div.popupDialog > div > div > div {
	text-align: center;
	padding: 10px;
}

/* assign floors to services */
.floorSelected td {
	background-color: #ACF !important;
}
.floorPartial td {
	background-color: #D1E4FF !important;
	background: repeating-linear-gradient( 135deg, #D1E4FF, #D1E4FF 5px, #E6F0FF 5px, #E6F0FF 10px) !important;
}
.floorNotSelected td {
	background-color: transparent;
	cursor: pointer;
}
form .helpButton .helpOrb {
	background-position: right top;
}

.purchaseOrderAddModDiv {
	background-color: #E0F0F9;
	z-index: 1002;
	display: none;
	position:fixed;
	left:5%;
	top:5%;
	opacity:1.0;
	width: 90%;
	height: 80%;
	overflow: auto;
	border-radius: 5px 5px 5px 5px;
	box-shadow: 5px 5px 30px 5px rgba(0,0,0,0.71);
	padding: 5px;
	border: none;
}