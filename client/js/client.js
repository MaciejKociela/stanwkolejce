 function ChatController($scope) {
     var socket = io.connect();
     $scope.nbr = 0;
     $scope.id = 0;
     $scope.queueChoose = true;
     $scope.hid = true;
     $scope.hidNbr = true;
     $scope.hidThanks = true;
     $scope.code;
     $scope.queueId = 0;
     $scope.h1hide = true;
     $scope.h2hide = true;
     $scope.inputHide = false;
     $scope.inputHide2 = false;
     $scope.text = 'hello';
     $scope.nazwa;
     $scope.records = [
         "PW MEiL",
         "PW MiNI",
         "PW EE",
         "PW Ch",
         "PW AiNS",
         "PW GiK"
     ];
     $scope.stanowisko = [];

     $scope.id = [];

     $scope.addQ = function addQ(data) {
         socket.emit('addQ', data);
     };

     $scope.setIn = function setIn(data) {
         $(document).ready(function() {
             $(".lineInput").slideUp();
             $(".setin").slideUp();
             $(".p").slideUp(2000);
         });
         $scope.hidNbr = false;
         $scope.$apply();
         socket.emit('setIn', data);
     };

     socket.on('connectionShop', function(data) {
         for (var i = 0; i < data.nb; i++) {
             $scope.id[i] = data.id[i] - 1 - data.numUsers[i];
         }
         $scope.stanowisko = data.stanowisko;
         $scope.$apply();
     });

     socket.on('changeNum', function(data) {
         $scope.nbr = data.numUsers[$scope.queueId];
         $scope.id = data.id[$scope.queueId] - 1;
         $scope.code = data.code[$scope.queueId][data.id[$scope.queueId] - 1];
         checkButtons();
     });



     socket.on('changeNumBroad', function(data) {
         navigator.vibrate(1000);
         
         $scope.nbr = data.numUsers[$scope.queueId];
         for (var i = 0; i < data.nb; i++) {
             $scope.id[i] = data.id[i] - 1 - data.numUsers[i];
         }
         
         checkButtons();
     });

     $scope.val = "";
     $scope.val2 = "";

     $scope.submit = function submit() {
         $scope.val = 'bb'
     }

     function checkButtons() {
         if ($scope.id - $scope.nbr < 1) {
             $scope.hidNbr = true;
         }
         if ($scope.id - $scope.nbr < 1 && $scope.id != 0) {
             $scope.hidThanks = false;
         }
         $scope.$apply();

     }

     $scope.LoadSessionData = function(val) {
         $scope.queueId = val;
         $scope.hid = false;
     }




     $scope.h1vis = function() {
         $scope.h1hide = false;
         $(document).ready(function() {
             $(".h").slideDown();
         });
     }

     $scope.h1click = function(val) {
         $(document).ready(function() {
             $(".h").slideUp();
         });

         $scope.val = val;
         $scope.inputHide2 = false;
     }

     $scope.h2vis = function() {
         $scope.h2hide = false;
         $(document).ready(function() {
             $(".lineButton").slideDown();


         });
     }
     $scope.me = 0;
     $scope.menu = function() {
         if ($scope.me == 0) {
             $scope.me = 1;
             $(document).ready(function() {
                 $('.info').slideDown(1000);
             });
         }
         else
         if ($scope.me == 1) {
             $scope.me = 0;
             $(document).ready(function() {

                 $('.info').slideUp(1000);
             });
         }

     }

     $scope.h2click = function(val) {
         $(document).ready(function() {
             $(".setIn").slideDown();
             $(".lineButton").slideUp();

         });
         $scope.val2 = val.name;
         $scope.queueId = val.id;
         $scope.hid = false;
     }
 }

 $(document).ready(function() {
     $('#nav-icon').click(function() {
         $(this).toggleClass('open');
     });
     $('.lineList').css("display", "block");
 });