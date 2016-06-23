//database.js

.import QtQuick.LocalStorage 2.0 as LS

// First, let's create a short helper function to get the database connection test
function getDatabase() {
    return LS.LocalStorage.openDatabaseSync("dicsgolf", "2.0", "StorageDatabase", 100000);
}

// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initialize() {
    var db = getDatabase();

    db.transaction(
                function(tx) {
                    tx.executeSql(
                                " CREATE TABLE IF NOT EXISTS spieler(" +
                                " Id INTEGER PRIMARY KEY AUTOINCREMENT," +
                                " NAME TEXT UNIQUE NOT NULL," +
                                " GEWAEHLT number," +
                                " FIRSTNAME," +
                                " LASTNAME," +
                                " EMAIL," +
                                " NOTES," +
                                " PDGA number," +
                                " PLAYEDROUNDS number," +
                                " AVERAGEPAR number," +
                                " TIMEPLAYED number)");

                    tx.executeSql("CREATE TABLE IF NOT EXISTS courses(" +
                                  "COURSE_ID INTEGER PRIMARY KEY AUTOINCREMENT," +
                                  "COURSENAME TEXT UNIQUE," +
                                  "BASKETS NUMBER," +
                                  "TOTALPAR NUMBER," +
                                  "NOTES," +
                                  "PLAYED number," +
                                  "BESTSCORE number," +
                                  "AVGSCORE )");

                    tx.executeSql("CREATE TABLE IF NOT EXISTS baskets(" +
                                  " BASKET_ID INTEGER PRIMARY KEY AUTOINCREMENT," +
                                  " BASKETNR," +
                                  " PAR number ," +
                                  " BASKETNAME," +
                                  " DISTANCE number," +
                                  " MANDO," +
                                  " NOTES," +
                                  " COURSE_ID NOT NULL)");

                    tx.executeSql("CREATE TABLE IF NOT EXISTS resultBasic(" +
                                  " RES_ID INTEGER PRIMARY KEY AUTOINCREMENT," +
                                  " DATE NOT NULL," +
                                  " COURSE_ID number ," +
                                  " TIME_PLAYED)");

                    tx.executeSql("CREATE TABLE IF NOT EXISTS resultDetail(" +
                                  " RES_ID number," +
                                  " Id number," +
                                  " COURSE_ID number ," +
                                  " BASKED_ID number ," +
                                  " PLAYERPAR number)");

                    tx.executeSql("CREATE TABLE IF NOT EXISTS endResult(" +
                                  " RES_ID number," +
                                  " Id number," +
                                  " COURSE_ID number ," +
                                  " PLAYERTOTALPAR number)");
                    //do I get the amount played? by select COURSE_ID AND Id --> how many rows and i get how often played!!!

                });
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// insert NAME, GEWAEHLT, FIRSTNAME, LASTNAME, EMAIL, NOTES,PDGA, PLAYEDROUNDS, TIMEPLAYED, ROUNDWON,
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// This function is used to write a setting into the database NAME
//USED in NewPlayer.qml

function insertNAME(NAME, GEWAEHLT, FIRSTNAME, LASTNAME, EMAIL, NOTES, PDGA, PLAYEDROUNDS, AVERAGEPAR, TIMEPLAYED) {
    var db = getDatabase();

    var res = "";
    db.transaction(function(tx) {
        // var rs = tx.executeSql("INSERT INTO spieler (NAME, GEWAEHLT, FIRSTNAME, LASTNAME, EMAIL, NOTES) VALUES (?,?,?,?,?,?);", [NAME, GEWAEHLT, FIRSTNAME, LASTNAME,EMAIL,NOTES]);
        var rs = tx.executeSql("INSERT INTO spieler (NAME, GEWAEHLT, FIRSTNAME, LASTNAME, EMAIL, NOTES,PDGA, PLAYEDROUNDS,AVERAGEPAR, TIMEPLAYED) VALUES (?,?,?,?,?,?,?,?,?,?);", [NAME, GEWAEHLT, FIRSTNAME, LASTNAME, EMAIL, NOTES, PDGA, PLAYEDROUNDS, AVERAGEPAR, TIMEPLAYED]);
    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//following is about sorting playeres in different ways
////////////////////////////////////////////////////////////////////////////////////////////////////////////

// sort by name added USED in Players.qml
function getNameAdded() {
    var nickname
    var gewaehlt
    var firstname
    var lastname
    var email
    var notes
    var roundplayed
    var timeplayed
    var averagepar

    //  var bogeys=234;
    //  var total=2345;

    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM spieler ORDER BY Id ASC;');
        for (var i = 0; i < rs.rows.length; i++) {
            //DEBUG
            //console.log(" ID:" + rs.rows.item(i).Id + " Amount of Players:" + rs.rows.length  + " NickName:" + rs.rows.item(i).NAME + " Selected:" + rs.rows.item(i).GEWAEHLT + " Firstname:" + rs.rows.item(i).FIRSTNAME +" Lastname:" + rs.rows.item(i).LASTNAME  +" Email:" + rs.rows.item(i).EMAIL+" Notes:" +rs.rows.item(i).NOTES+" played:" + rs.rows.item(i).PLAYEDROUNDS +" TimePlayed:" + rs.rows.item(i).TIMEPLAYED+ " AveragePar:" +rs.rows.item(i).AVERAGEPAR  )
            nickname = rs.rows.item(i).NAME
            gewaehlt = rs.rows.item(i).GEWAEHLT
            firstname = rs.rows.item(i).FIRSTNAME
            lastname = rs.rows.item(i).LASTNAME
            email = rs.rows.item(i).EMAIL
            notes = rs.rows.item(i).NOTES
            averagepar = rs.rows.item(i).AVERAGEPAR
            roundplayed = rs.rows.item(i).PLAYEDROUNDS
            timeplayed = rs.rows.item(i).TIMEPLAYED

            var elapsed = timeplayed;
            var minutes = parseInt((elapsed / (1000 * 60)) % 60)
            var hours = parseInt((elapsed / (1000 * 60 * 60)) % 24);
            var days = parseInt(elapsed / (1000*60*60*24));
            hours = (hours < 10) ? "0" + hours : hours;
            minutes = (minutes < 10) ? "0" + minutes : minutes;
            timeplayed = days.toString() +"d " +hours.toString() + "h " + minutes.toString() + "min "

            var parorboogey1=parorboogey(nickname);
            player.append({
                              nickname: nickname,
                              firstname: firstname,
                              gewaehlt: gewaehlt,
                              lastname: lastname,
                              email: email,
                              notes: notes,
                              roundplayed: roundplayed,
                              timeplayed: timeplayed,
                              averagepar: averagepar,
                              aces:parorboogey1[0],
                              eagle:parorboogey1[1],
                              birdies:parorboogey1[2],
                              pars: parorboogey1[3],
                              bogeys:parorboogey1[4],
                              rest:parorboogey1[5],
                              total:parorboogey1[6],
                          });
        }
    })
}

//USED in NewGame.qml
function sortBySelected() {
    var nickname
    var gewaehlt
    var firstname
    var lastname
    var spielergewaehlt = 0
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM spieler ORDER BY GEWAEHLT DESC;');
        for (var i = 0; i < rs.rows.length; i++) {
            nickname = rs.rows.item(i).NAME
            gewaehlt = rs.rows.item(i).GEWAEHLT
            firstname = rs.rows.item(i).FIRSTNAME
            lastname = rs.rows.item(i).LASTNAME
            player.append({
                              nickname: nickname,
                              firstname: firstname,
                              gewaehlt: gewaehlt,
                              lastname: lastname
                          });
        }
    })
}

// sort by name added
//USED in Round.qml Round_Results.qml and Round_Scorecard.qml

function getNickNameAddedSelected() {
    var nickname
    var namearray = []

    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM spieler WHERE GEWAEHLT=1 ORDER BY Id ASC;');
        for (var i = 0; i < rs.rows.length; i++) {
            //DEBUG
            //////console.log(" ID:" + rs.rows.item(i).Id + " Anzahl:" + rs.rows.length  + " NAME:" + rs.rows.item(i).NAME + " Selected:" + rs.rows.item(i).GEWAEHLT + " Firstname:" + rs.rows.item(i).FIRSTNAME +" Lastname:" + rs.rows.item(i).LASTNAME  +" played:" + rs.rows.item(i).PLAYEDROUND  )
            nickname = rs.rows.item(i).NAME
            namearray[i] = nickname;
            //player.append({nickname:nickname});
        }
    })

    return namearray;
}
// get player selected
//USED in NewGame.qml
function playerselected() {
    var spielergewaehlt= false
    var db = getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM spieler WHERE GEWAEHLT=1;');
        if (rs.rows.length >0) {
            spielergewaehlt = true
        }
    })
    return spielergewaehlt;
}

//USED in Round_Scorecard.qml

function updatePLAYEDROUNDSplayer(elapsed) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql("UPDATE spieler SET PLAYEDROUNDS=PLAYEDROUNDS+1 WHERE GEWAEHLT=1;");
        var rss = tx.executeSql("UPDATE spieler SET TIMEPLAYED=TIMEPLAYED + '" + elapsed + "' WHERE GEWAEHLT=1;");

    }

    // var rs = tx.executeSql("UPDATE spieler SET PLAYEDROUNDS=PLAYEDROUNDS+1 AND TIMEPLAYED=TIMEPLAYED+elapsedtime WHERE GEWAEHLT=1");}

    );
    return result;
}

//USED in Round_Scorecard.qml

function updatePLAYED(coursename) {
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql("UPDATE courses SET PLAYED=PLAYED+1 WHERE COURSENAME=?;", [coursename]);
    }

    );
    return result;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//following is about edit existing players in the database
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//USED in EditPlayers.qml
function editPlayer( nickNameEdit, nickName, firstName, lastName, pdga, email, notes) {
    var db = getDatabase();
    var Id= getspielerIDfromName(nickNameEdit)
    // //////console.log(" neuer name: " + namee + " alter name: " + editname )
    db.transaction(function(tx) {
        tx.executeSql("UPDATE spieler SET NAME ='" + nickName + "' WHERE Id='" + Id + "'");
        tx.executeSql("UPDATE spieler SET FIRSTNAME ='" + firstName + "' WHERE Id='" + Id + "'");
        tx.executeSql("UPDATE spieler SET LASTNAME ='" + lastName + "' WHERE Id='" + Id + "'");
        tx.executeSql("UPDATE spieler SET EMAIL ='" + email + "' WHERE Id='" + Id + "'");
        tx.executeSql("UPDATE spieler SET PDGA ='" + pdga + "' WHERE Id='" + Id + "'");
        tx.executeSql("UPDATE spieler SET NOTES ='" + notes + "' WHERE Id='" + Id + "'");
        //für das brauchte ich fast nen ganzen tag:   '" + username + "' "
    });
}

/////////////////////////////////////////////////////////////////
//FOLLOWING IS ABOUT SELECTING PLAYERS FOR NEW GAME
/////////////////////////////////////////////////////////////////

//USED in NewGame.qml
function checkSelect(nickNameEdit) {
    var selected
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var res = tx.executeSql("SELECT GEWAEHLT from spieler WHERE NAME='" + nickNameEdit + "'  ");
        selected = res.rows.item(0).GEWAEHLT
    })
    return selected;
}

//USED in Round.qml
function getcountSelectet() {
    var countselected;
    var db = getDatabase();
    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT GEWAEHLT FROM spieler WHERE GEWAEHLT=1");
        countselected = rss.rows.length
    })
    return countselected;
}

//USED in NewGame.qml
function playerSelect(nickname) {
    var db = getDatabase();
    var selectedit = "";
    db.transaction(function(tx) {
        var selectedit = tx.executeSql("UPDATE spieler SET GEWAEHLT =1 WHERE NAME='" + nickname + "' ");
    });
}

//USED in NewGame.qml
function playerUnSelect(nickname) {
    var db = getDatabase();
    var selectedit = "";

    db.transaction(function(tx) {
        var selectedit = tx.executeSql("UPDATE spieler SET GEWAEHLT =0 WHERE NAME='" + nickname + "'  ");

    });
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//COURSES//
// insert COURSENAME,BASKETS,TOTALPAR, NOTES,
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//USED in DefinePar.qml
// This function is used to write a setting into the database courses
function insertCOURSE(COURSENAME, BASKETS, TOTALPAR, NOTES, PLAYED, BESTSCORE, AVGSCORE) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql("INSERT INTO courses (COURSENAME, BASKETS,TOTALPAR, NOTES, PLAYED, BESTSCORE,AVGSCORE) VALUES (?,?,?,?,?,?,?);", [COURSENAME, BASKETS, TOTALPAR, NOTES, PLAYED, BESTSCORE, AVGSCORE]);
        //console.log("INSERT COURSENAME: " +COURSENAME+ " INSERT BASKETS: "+ BASKETS+ " INSERT TOTALPAR: "+ TOTALPAR+ " INSERT NOTES "+ NOTES);

    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}

//UPDATE course played count
//USED in Round_Scorecard.qml
function updatePLAYED(coursename) {
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql("UPDATE courses SET PLAYED=PLAYED+1 WHERE COURSENAME=?;", [coursename]);
    }

    );
    return result;
}

//USED in NewCourses.qml to check if the courseName already exist
function checkCourseName(coursename) {
    var db = getDatabase();
    var result = "";

    db.transaction(function(tx) {
        //var rs = tx.executeSql('SELECT COURSENAME FROM courses WHERE coursename=? ', [coursename]);
        var rs = tx.executeSql('SELECT COURSENAME FROM courses WHERE coursename=? ', coursename);

        if (rs.rows.length > 0) {
            result = rs.rows.item(0).COURSENAME
        } else {
            result = 1
        }
        //////console.log("das resultat lautet:"+ result)
    });
    return result;
}

// This function is used to write a setting into the database baskets
//USED in DefinePar.qml
function insertBASKETS(BASKETNR, PAR, COURSE_ID) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql("INSERT INTO baskets (BASKETNR, PAR, COURSE_ID) VALUES (?,?,?);", [BASKETNR, PAR, COURSE_ID]);
        //console.log("INSERT BASKETNR: " +BASKETNR+ " INSERT BASKETPAR: "+ PAR +" INSERT COURSE_ID: " +COURSE_ID);
    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}

//USED in Courses.qml and NewCourses.qml
function getBaskets() {
    var BASKET_ID
    var BASKETNR
    var PAR
    var BASKETNAME
    var DISTANCE
    var MANDO
    var NOTES
    var COURSE_ID

    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql("SELECT * FROM  baskets");

        for (var i = 0; i < rs.rows.length; i++) {

            BASKET_ID = rs.rows.item(i).BASKET_ID
            BASKETNR = rs.rows.item(i).BASKETNR
            PAR = rs.rows.item(i).PAR
            BASKETNAME = rs.rows.item(i).BASKETNAME
            DISTANCE = rs.rows.item(i).DISTANCE
            MANDO = rs.rows.item(i).MANDO
            NOTES = rs.rows.item(i).NOTES
            COURSE_ID = rs.rows.item(i).COURSE_ID
            // courses.append({BASKET_ID:BASKET_ID, BASKETNR:BASKETNR, PAR:PAR,BASKETNAME:BASKETNAME,DISTANCE:DISTANCE,MANDO:MANDO,NOTES:NOTES,COURSE_ID:COURSE_ID});
            //console.log( "BASKET ID: "+BASKET_ID + " BASKETNR: "+ BASKETNR+ " PAR: "+PAR+ " BASKETNAME: "+BASKETNAME+ " DISTANCE: "+DISTANCE+ " MANDO: "+ MANDO+ " NOTES: " +NOTES+ " COURSE_ID: " +COURSE_ID)
        }
    })
}



////////////////getCourses
// sort by date
//USED in Courses.qml and NewGameCourses.qml
function getCourses() {
    var id
    var coursename
    var baskets
    var basketnr
    var basketname
    var par
    var totalpar
    var played
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT COURSENAME, BASKETS, TOTALPAR, PLAYED FROM courses ORDER BY COURSE_ID ASC;');
        for (var i = 0; i < rs.rows.length; i++) {
            coursename = rs.rows.item(i).COURSENAME
            baskets = rs.rows.item(i).BASKETS
            totalpar = rs.rows.item(i).TOTALPAR
            played = rs.rows.item(i).PLAYED
            courses.append({
                               coursename: coursename,
                               baskets: baskets,
                               totalpar: totalpar,
                               played: played
                           });
        }
    })
}
//USED in DefinePar.qml and Round.qml and Round_Chart.qml and Round_Result.qml and Round_Scorecard.qml
function getCourseID(coursename) {
    var db = getDatabase();
    var res = "";
    var id
    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT COURSE_ID FROM courses WHERE COURSENAME = '" + coursename + "' ");
        for (var i = 0; i < rss.rows.length; i++) {
            id = rss.rows.item(i).COURSE_ID
        }
        res = id;
    })
    return res;
}

// USED in Courses.qml (not in use eg //)
function getCoursesDEBUG() {
    var id
    var coursename
    var baskets
    var basketnr
    var basketname
    var par
    var totalpar
    var distance
    var ob
    var mando
    var notes

    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT DISTINCT COURSENAME, BASKETS, BASKETNR,BASKETNAME,PAR,TOTALPAR, DISTANCE,OB,MANDO,NOTES FROM courses ORDER BY Id ASC;');
        for (var i = 0; i < rs.rows.length; i++) {

            coursename = rs.rows.item(i).COURSENAME
            baskets = rs.rows.item(i).BASKETS
            basketnr = rs.rows.item(i).BASKETNR
            basketname = rs.rows.item(i).BASKETNAME
            par = rs.rows.item(i).PAR
            totalpar = rs.rows.item(i).TOTALPAR
            distance = rs.rows.item(i).DISTANCE
            ob = rs.rows.item(i).OB
            mando = rs.rows.item(i).MANDO
            notes = rs.rows.item(i).NOTES
            //console.log( "COURSENAME:" + coursename+   " BASKETS:"+ baskets+ " BasketNR:"+basketnr+ " Basketname:"+ basketname+ " PAR:" +par+ " Totalpar:"+totalpar+" Distance:"+distance+ " OB:" +ob+ " Mando:"+ mando+ " Notes:"+notes);

        }
    })
}


//USED in Round.qml Round_Chart.qml Round_Result.qml and Round_Scorecard.qml
function getPar(basketnr, coursename) {
    var db = getDatabase();
    var res = "";
    var PARBASKET;

    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT PAR FROM baskets WHERE COURSE_ID = " + coursename + " AND BASKETNR = " + basketnr + " ");

        // var rss = tx.executeSql("SELECT PAR FROM baskets WHERE COURSE_ID = 1 AND BASKETNR = "+basketnr+"");
        PARBASKET = rss.rows.item(0).PAR
        res = PARBASKET;

    })
    //console.log("PAR BASKET: " + PARBASKET);
    return res;

}

/////////////////////////////////////////////////////////////////
//FOLLOWING IS ABOUT current GAME
/////////////////////////////////////////////////////////////////


//USED in Round_Scorcard.qml
function getspielerID(currentindex) {

    var db = getDatabase();
    var res = "";
    var id
    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT Id FROM spieler WHERE GEWAEHLT=1");
        id = rss.rows.item(currentindex).Id

        res = id;
    })
    return res;
}

//USED in Round_Scorecard.qml
function getspielerIDfromName(name) {

    var db = getDatabase();
    var res = "";
    var id
    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT Id FROM spieler WHERE NAME = '" + name + "' ");

        for (var i = 0; i < rss.rows.length; i++) {
            id = rss.rows.item(i).Id
        }
        res = id;
    })
    return res;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FOLLOWING is about RESULT
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

//USED in Round_Scorecard.qml
function insertBaseResult(DATE, COURSE_ID, TIME_PLAYED) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql("INSERT INTO resultBasic (DATE, COURSE_ID, TIME_PLAYED) VALUES (?,?,?);", [DATE, COURSE_ID, TIME_PLAYED]);
    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}

//DEBUGING USED in FirstPage.qml
function getBaseResult() {
    var RES_ID
    var DATE
    var COURSE_ID
    var TIME_PLAYED
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM resultBasic;');
        for (var i = 0; i < rs.rows.length; i++) {
            RES_ID = rs.rows.item(i).RES_ID
            DATE = rs.rows.item(i).DATE
            COURSE_ID = rs.rows.item(i).COURSE_ID
            TIME_PLAYED = rs.rows.item(i).TIME_PLAYED
            //console.log( "RES_ID:" + RES_ID+   " DATE:"+ DATE+ " COURSE_ID:"+COURSE_ID+ " TIME_PLAYED:"+ TIME_PLAYED);
        }
    });
}

//USED in Round_Scorecard.qml
function getRES_ID() {
    var db = getDatabase();
    var res = "";
    var RES_ID;

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM resultBasic order by RES_ID desc limit 1;');
        RES_ID = rs.rows.item(0).RES_ID
        //console.log( "RES_ID last:" + RES_ID);
    });
    return RES_ID;

}

//USED in Round_Scorecard.qml
function insertDetailResult(RES_ID, Id,COURSE_ID, BASKED_ID, PLAYERPAR) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql("INSERT INTO resultDetail (RES_ID,Id, COURSE_ID, BASKED_ID, PLAYERPAR) VALUES (?,?,?,?,?);", [RES_ID, Id, COURSE_ID, BASKED_ID, PLAYERPAR]);
        //console.log("instert resultBasic");
    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}

//USED in Round_Scorecard.qml
function endResult(RES_ID, Id,COURSE_ID, PLAYERTOTALPAR) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql("INSERT INTO endResult (RES_ID,Id, COURSE_ID, PLAYERTOTALPAR) VALUES (?,?,?,?);", [RES_ID, Id, COURSE_ID, PLAYERTOTALPAR]);
        //console.log("instert resultBasic");
    });
    // The function returns “OK” if it was successful, or “Error” if it wasn't
    return res;
}


//DEBUGING USED in FirstPage.qml
function getDetailResult() {
    var RES_ID
    var Id
    var BASKED_ID
    var PLAYERPAR
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM resultDetail;');
        for (var i = 0; i < rs.rows.length; i++) {
            RES_ID = rs.rows.item(i).RES_ID
            Id = rs.rows.item(i).Id
            BASKED_ID = rs.rows.item(i).BASKED_ID
            PLAYERPAR = rs.rows.item(i).PLAYERPAR
            //console.log( "RES_ID:" + RES_ID+   " Id:"+ Id+ " BASKED_ID:"+BASKED_ID+ " PLAYERPAR:"+ PLAYERPAR);
        }
    });
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//following is about deleting tables
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//USED in NewGame.qml and Players.qml
function dropTables() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    // spieler löschen
                    tx.executeSql("DROP TABLE IF EXISTS spieler");

                })
}

//USED in Settings.qml RESET ALL
function dropAll() {
    var db = getDatabase();

    db.transaction(
                function(tx) {
                    // delete all
                    tx.executeSql("DROP TABLE IF EXISTS spieler");
                    tx.executeSql("DROP TABLE IF EXISTS courses");
                    tx.executeSql("DROP TABLE IF EXISTS baskets");
                    tx.executeSql("DROP TABLE IF EXISTS resultDetail");
                    tx.executeSql("DROP TABLE IF EXISTS endResult");
                    tx.executeSql("DROP TABLE IF EXISTS resultBasic");
                })
}

function dropCourses() {
    var db = getDatabase();

    db.transaction(
                function(tx) {
                    // delete all
                    tx.executeSql("DROP TABLE IF EXISTS spieler");
                    tx.executeSql("DROP TABLE IF EXISTS courses");
                    tx.executeSql("DROP TABLE IF EXISTS baskets");
                    tx.executeSql("DROP TABLE IF EXISTS resultDetail");
                    tx.executeSql("DROP TABLE IF EXISTS endResult");
                    tx.executeSql("DROP TABLE IF EXISTS resultBasic");
                })
}

//USED in NewGame.qml and Players.qml
function deletePlayer(nameLoeschen) {
    var db = getDatabase();
    var playerID= getspielerIDfromName(nameLoeschen);
    db.transaction(
                function(tx) {
                    // spieler löschen
                    tx.executeSql("DELETE FROM spieler WHERE Id = ?", playerID );
                    tx.executeSql("DELETE FROM resultDetail WHERE Id = ?", playerID );
                    tx.executeSql("DELETE FROM endResult WHERE Id = ?", playerID );
                }
                )
}
//Used in Courses.qml and DefinePar.qml and NewCourses.qml and NewGameCourses.qml
function deleteCourse(courseLoeschen) {
    var db = getDatabase();
    var courseID=getCourseID(courseLoeschen);
    db.transaction(
                function(tx) {
                    // course löschen
                    tx.executeSql("DELETE FROM courses WHERE COURSE_ID = ? ", courseID);
                    tx.executeSql("DELETE FROM baskets WHERE COURSE_ID = ? ", courseID);
                    tx.executeSql("DELETE FROM resultBasic WHERE COURSE_ID = ? ", courseID);
                    tx.executeSql("DELETE FROM resultDetail WHERE COURSE_ID = ? ", courseID);
                    tx.executeSql("DELETE FROM endResult WHERE COURSE_ID = ? ", courseID);

                    //console.log("DELETE COURSE: " + courseLoeschen);
                }
                )
}


function deleteGame(res_id) {
    var db = getDatabase();
    db.transaction(
                function(tx) {

                    tx.executeSql("DELETE FROM resultBasic WHERE RES_ID = ? ", res_id);
                    tx.executeSql("DELETE FROM resultDetail WHERE RES_ID = ? ", res_id);
                    tx.executeSql("DELETE FROM endResult WHERE RES_ID = ? ", res_id);


                }
                )
}




////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
///////////////STATISTICS//////////////////////////////////////////////////

//AVERAGE PAR of course
//used in course.qml and newgamecourses.qml
function getAverageCourse(coursename) {
    var db = getDatabase();
    var courseID=getCourseID(coursename);
    var sum=0;
    var average;
    db.transaction(
                function(tx) {
                    var rss = tx.executeSql("SELECT PLAYERTOTALPAR FROM endResult WHERE COURSE_ID = ? ", courseID);
                    for (var i = 0; i < rss.rows.length; i++) {
                        sum = sum + rss.rows.item(i).PLAYERTOTALPAR
                        //debug
                        //console.log("sum = sum + rss.rows.item(i).PLAYERTOTALPAR" + sum)

                    }
                    if (rss.rows.length>0) {

                        sum=sum/rss.rows.length;
                        average=sum.toFixed(2);
                        //debug
                        //console.log(" if (rss.rows.length>0)" + rss.rows.length)

                    }
                    else {
                        average="--"
                    }
                }

                )
    return average;
}

//BESTSCORE of course
//used in course.qml and newgamecourses.qml
function getBestScoreCourse(coursename) {
    var db = getDatabase();
    var courseID=getCourseID(coursename);
    var bestscore=0;
    db.transaction(
                function(tx) {
                    // course löschen
                    var rss = tx.executeSql("SELECT PLAYERTOTALPAR FROM endResult WHERE COURSE_ID = ? ORDER BY PLAYERTOTALPAR ASC;", courseID);
                    if (rss.rows.length > 0) {
                        bestscore=rss.rows.item(0).PLAYERTOTALPAR
                    }
                    else{
                        bestscore="--"
                    }
                })
    return bestscore;
}

//AVERAGE PAR of PLAYER
//used in player.qml
function getAveragePlayer(nickname) {
    var db = getDatabase();
    var spierlerId=getspielerIDfromName(nickname);
    var sum=0;
    var average;
    db.transaction(
                function(tx) {
                    // course löschen
                    var rss = tx.executeSql("SELECT PLAYERTOTALPAR FROM endResult WHERE Id = ? ", spierlerId);
                    for (var i = 0; i < rss.rows.length; i++) {
                        sum = sum + rss.rows.item(i).PLAYERTOTALPAR
                    }
                    if (rss.rows.length >0) {
                        sum=sum/rss.rows.length;
                        average=sum.toFixed(2);
                    }
                    else {
                        average="--"
                    }
                }
                )
    return average;
}

//AVERAGE PAR of PLAYER per basket
//used in round.qml and round2.qml
function getAverageBasketPlayer(name,coursename, basketnummer) {
    var db = getDatabase();
    var courseID=getCourseID(coursename);
    var spierlerId=getspielerIDfromName(name)
    var sum=0;
    var average;
    db.transaction(
                function(tx) {
                    // course löschen
                    var rss = tx.executeSql("SELECT PLAYERPAR FROM resultDetail WHERE Id =? AND COURSE_ID =? AND BASKED_ID =? ;",[spierlerId,courseID, basketnummer]);
                    for (var i = 0; i < rss.rows.length; i++) {
                        sum = sum + rss.rows.item(i).PLAYERPAR
                    }
                    if (rss.rows.length >0) {
                        sum=sum/rss.rows.length;
                        average=sum.toFixed(2);
                    }

                    else {
                        average="--";
                    }
                }
                )
    return average;
}
function getAverageBasket(coursename, basketnummer) {
    var db = getDatabase();
    var courseID=getCourseID(coursename);
    var sum=0;
    var average;
    db.transaction(
                function(tx) {
                    // course löschen
                    var rss = tx.executeSql("SELECT PLAYERPAR FROM resultDetail WHERE COURSE_ID =? AND BASKED_ID =? ;",[courseID, basketnummer]);
                    for (var i = 0; i < rss.rows.length; i++) {
                        sum = sum + rss.rows.item(i).PLAYERPAR
                    }
                    if (rss.rows.length >0) {
                        sum=sum/rss.rows.length;
                        average=sum.toFixed(2);
                    }
                    else {
                        average="--";
                    }
                }
                )
    return average;
}

function getAveragePlayerCourse(nickname,coursename) {
    var db = getDatabase();
    var spierlerId=getspielerIDfromName(nickname);
    var courseID=getCourseID(coursename);
    var sum=0;
    var average;
    db.transaction(
                function(tx) {
                    // course löschen
                    var rss = tx.executeSql("SELECT PLAYERTOTALPAR FROM endResult WHERE Id = ? AND COURSE_ID =? ;",[spierlerId, courseID]);
                    for (var i = 0; i < rss.rows.length; i++) {
                        sum = sum + rss.rows.item(i).PLAYERTOTALPAR
                    }
                    if (rss.rows.length >0) {
                        sum=sum/rss.rows.length;
                        average=sum.toFixed(2);
                    }
                    else {
                        average="--"
                    }
                }
                )
    return average;
}

//best per basket per player:
function getBestScoreBasket(currentindex,coursename, basketnummer) {
    var db = getDatabase();
    var spierlerId=getspielerID(currentindex);
    var courseID=getCourseID(coursename);
    var bestscore=0;
    db.transaction(
                function(tx) {
                    // course löschen
                    var rss = tx.executeSql("SELECT PLAYERPAR FROM resultDetail WHERE Id =? AND COURSE_ID =? AND BASKED_ID =? ORDER BY PLAYERPAR ASC;",[spierlerId,courseID, basketnummer]);
                    if (rss.rows.length >0) {
                        bestscore=rss.rows.item(0).PLAYERPAR
                    }
                    else {
                        bestscore="--"
                    }
                })
    return bestscore;
}

//worst per basket per player:
function getWorstScoreBasket(currentindex,coursename, basketnummer) {
    var db = getDatabase();
    var spierlerId=getspielerID(currentindex);
    var courseID=getCourseID(coursename);
    var worstscore=0;
    db.transaction(
                function(tx) {
                    // course löschen
                    var rss = tx.executeSql("SELECT PLAYERPAR FROM resultDetail WHERE Id =? AND COURSE_ID =? AND BASKED_ID =? ORDER BY PLAYERPAR DESC;",[spierlerId,courseID, basketnummer]);

                    if (rss.rows.length >0) {
                        worstscore=rss.rows.item(0).PLAYERPAR
                    }
                    else {
                        worstscore="--"
                    }
                }
                )
    return worstscore;
}
//best per course per player:
function getBestplayerCourse(coursename , nickname) {
    var db = getDatabase();
    var spielerId=getspielerIDfromName(nickname);
    var courseID=getCourseID(coursename);
    var bestscore=0;
    db.transaction(
                function(tx) {
                    var rss = tx.executeSql("SELECT PLAYERTOTALPAR FROM endResult WHERE Id=? AND COURSE_ID =? ORDER BY PLAYERTOTALPAR ASC;",[spielerId , courseID]);
                    if (rss.rows.length >0) {
                        bestscore=rss.rows.item(0).PLAYERTOTALPAR
                    }
                    else {
                        bestscore="--"
                    }
                })
    return bestscore;
}

//course how often played per player
function getAmountPlayedPlayer(coursename,nickname){
    var db = getDatabase();
    var spielerId= getspielerIDfromName(nickname);
    var courseID=getCourseID(coursename);
    var amount;
    db.transaction(
                function(tx) {
                    var rss = tx.executeSql("SELECT RES_ID FROM endResult WHERE Id=? AND COURSE_ID =? ;",[spielerId , courseID]);
                    if (rss.rows.length >0) {
                        amount=rss.rows.length;
                    }
                    else {
                        amount="--"
                    }
                }
                )
    return amount;
}





//show aces boogies pars and so on:
// get count from resultDetail where PLYERPAR =





function parorboogey(nickname){
    var spielerId= getspielerIDfromName(nickname);
    var basket_id;
    var course_id;
    var playerpar
    var basketpar
    var db = getDatabase();
    var acereturn=0;
    var eaglereturn=0;
    var birdiereturn=0;
    var parreturn=0;
    var boogiereturn=0;
    var restreturn=0;
    var totalreturn=0;


    db.transaction(
                function(tx) {
                    var rss = tx.executeSql("SELECT PLAYERPAR, COURSE_ID, BASKED_ID FROM resultDetail WHERE Id=? ;",[spielerId]);
                    for (var i = 0; i < rss.rows.length; i++) {
                        playerpar = rss.rows.item(i).PLAYERPAR
                        course_id = rss.rows.item(i).COURSE_ID
                        basket_id = rss.rows.item(i).BASKED_ID
                        basketpar=getPar(basket_id, course_id)

                        if (basketpar===3)
                        {
                            switch(basketpar-playerpar){
                            case 0:
                                parreturn+=1
                                break;
                            case 1:
                                birdiereturn+=1
                                break;
                            case 2:
                                acereturn+=1
                                break;
                            case -1:
                                boogiereturn+=1
                                break;

                            }


                        }

                        if (basketpar===4)
                        {
                            switch(basketpar-playerpar){
                            case 0:
                                parreturn+=1
                                break;
                            case 1:
                                birdiereturn+=1
                                break;
                            case 2:
                                eaglereturn+=1
                                break;
                            case 3:
                                acereturn+=1
                                break;
                            case -1:
                                boogiereturn+=1
                                break;

                            }

                        }
                        if (basketpar===5)
                        {
                            switch(basketpar-playerpar){
                            case 0:
                                parreturn+=1
                                break;
                            case 1:
                                birdiereturn+=1
                                break;
                            case 2:
                                eaglereturn+=1
                                break;
                            case 3:
                                albatrossreturn+=1
                                break;
                            case 4:
                                acereturn+=1
                                break;
                            case -1:
                                boogiereturn+=1
                                break;

                            }

                        }



                        if (basketpar===6)
                        {
                            switch(basketpar-playerpar){
                            case 0:
                                parreturn+=1
                                break;
                            case 1:
                                birdiereturn+=1
                                break;
                            case 2:
                                eaglereturn+=1
                                break;
                            case 3:
                                albatrossreturn+=1
                                break;
                            case 5:
                                acereturn+=1
                                break;
                            case -1:
                                boogiereturn+=1
                                break;

                            }

                        }

                    }

                    var all = tx.executeSql("SELECT PLAYERPAR FROM resultDetail WHERE Id=? ;",[spielerId]);
                    totalreturn= all.rows.length
                }
                )
    restreturn= totalreturn-(acereturn+eaglereturn+birdiereturn+parreturn+boogiereturn)
    return [acereturn,eaglereturn,birdiereturn,parreturn,boogiereturn,restreturn,totalreturn];
}

///////////////////////////////////////SCORECARDS
function getGamesbyDate() {
    var res_id;
    var date;
    var course_id;
    var time_played;
    var coursename;
    var coursepar;
    var bestscore;
    var playerName = [];

    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM resultBasic ORDER BY RES_ID DESC; ');
        for (var i = 0; i < rs.rows.length; i++) {
            //DEBUG
            res_id=rs.rows.item(i).RES_ID
            date = rs.rows.item(i).DATE
            course_id = rs.rows.item(i).COURSE_ID
            time_played = rs.rows.item(i).TIME_PLAYED

            var elapsed = time_played;
            var minutes = parseInt((elapsed / (1000 * 60)) % 60)
            var hours = parseInt((elapsed / (1000 * 60 * 60)) % 24);
            //var days = parseInt(elapsed / (1000*60*60*24));
            hours = (hours < 10) ? "0" + hours : hours;
            minutes = (minutes < 10) ? "0" + minutes : minutes;
            time_played = hours.toString() + "h " + minutes.toString() + "min "

            coursename=getCourseNamebyID(course_id);
            coursepar=getCourseParbyID(course_id);
            bestscore=getBestScoreCourse(coursename);
            playerName=getPlayersbyRESID(res_id);
            //            console.log(" DATE:" + date + " COURSENAME:" + coursename +" ("+coursepar+")" + " TIME_PLAYED:" + time_played +"best course: " + bestscore + " playername: " + playerName )
            playerName=playerName.toString();
            //playerName = playerName.replace(/(\w+\W+\w+)\W+/ig,"$1\n");

            playerName = playerName.replace(/,/g," ");

            score.append({
                             "datum": date,
                             "coursename": coursename,
                             "coursepar": coursepar,
                             "timeplayed": time_played,
                             "bestscore": bestscore,
                             "players":playerName,
                             "res_id":res_id,
                         });

        }
    })
}



function getCourseNamebyID(courseID) {
    var db = getDatabase();
    var res = "";
    var name;
    var coursepar;
    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT COURSENAME, TOTALPAR FROM courses WHERE COURSE_ID = '" + courseID + "' ");
        for (var i = 0; i < rss.rows.length; i++) {
            name = rss.rows.item(i).COURSENAME
            coursepar=rss.rows.item(i).TOTALPAR
        }
        res = name;
    })
    return res;

}

function getCourseParbyID(courseID) {
    var db = getDatabase();
    var res = "";
    var name;
    var coursepar;
    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT COURSENAME, TOTALPAR FROM courses WHERE COURSE_ID = '" + courseID + "' ");
        for (var i = 0; i < rss.rows.length; i++) {
            name = rss.rows.item(i).COURSENAME
            coursepar=rss.rows.item(i).TOTALPAR
        }
        res = coursepar;
    })
    return res;

}

//get players name and played par for specific resID


function getPlayersbyRESID(res_id){
    var db = getDatabase();
    var playerID = [];//create an empty array (don't know how many players played!!!
    var playerName = [];

    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT DISTINCT Id FROM resultDetail WHERE RES_ID = '" + res_id + "' ");
        for (var i = 0; i < rss.rows.length; i++) {
            playerID[i] = rss.rows.item(i).Id
            playerName[i]=getSpielerNamebyID(playerID[i]) + "("+getPlayersEndPar(res_id, playerID[i]) +") ";

            players.append({
                               players:getSpielerNamebyID(playerID[i])
                           })

            playerstotalpar.append({
                               playerstotalpar:getPlayersEndPar(res_id, playerID[i])
                           })                                             
        }
    })

    return playerName;

}


function getSpielerNamebyID(playerID) {
    var db = getDatabase();
    var res = "";
    var name;
    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT NAME FROM spieler WHERE Id = '" + playerID + "' ");
        for (var i = 0; i < rss.rows.length; i++) {
            name = rss.rows.item(i).NAME
        }
        res = name;
    })
    return res;

}







function getPlayersEndPar(res_id, playerID)  {
    var id
    var playerstotalpar
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {

        var rs = tx.executeSql("SELECT PLAYERTOTALPAR FROM endResult WHERE RES_ID =? AND Id =? ; ",[res_id, playerID]);
        for (var i = 0; i < rs.rows.length; i++) {
            //DEBUG
            playerstotalpar = rs.rows.item(i).PLAYERTOTALPAR
        }
    })
    return playerstotalpar;

}


///create scorecards

function getamountBaskets(coursename) {
    var db = getDatabase();
    var res = "";
    var baskets
    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT BASKETS FROM courses WHERE COURSENAME = '" + coursename + "' ");
        for (var i = 0; i < rss.rows.length; i++) {
            baskets = rss.rows.item(i).BASKETS
        }
        res = baskets;
    })
    return res;

}

//select  PLAYERPAR from resultDetail  NEED Id from playersname

function getIdbyplayersName(name) {
    var db = getDatabase();
    var res = "";
    var Id
    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT Id FROM spieler WHERE NAME = '" + name + "' ");
        for (var i = 0; i < rss.rows.length; i++) {
            Id = rss.rows.item(i).Id
        }
       res = Id;
    })
    return res;

}

function getPlayerParBasket(res_id,Id,courseID ) {
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT PLAYERPAR FROM resultDetail WHERE RES_ID =? AND Id =? ; ",[res_id, Id]);
        for (var i = 0; i < rss.rows.length; i++) {
            res = rss.rows.item(i).PLAYERPAR
            res=res-(getPar((i+1), courseID))

                 result.append({
                                  result:res
                                  })        }
    })
    return res;
}

function getSpielerIDbyResId(res_id,coursename) {
    var db = getDatabase();
    var res = "";
   var playerID = []
    db.transaction(function(tx) {
        var rss = tx.executeSql("SELECT DISTINCT Id FROM endResult WHERE RES_ID = '" + res_id + "' ");
        for (var i = 0; i < rss.rows.length; i++) {
            playerID[i] = rss.rows.item(i).Id
             getPlayerParBasket(res_id,playerID[i],getCourseID(coursename) )

        }
    })
    return res;

}

//////////////////////////DEBUGING show tables
//spieler courses baskets resultBasic resultDetail endResult

/*

function showSpieler() {
    var nickname
    var gewaehlt
    var firstname
    var lastname
    var email
    var notes
    var pdga
    var roundplayed
    var timeplayed
    var averagepar

    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM spieler');
        for (var i = 0; i < rs.rows.length; i++) {
            //DEBUG
            //console.log(" ID:" + rs.rows.item(i).Id + " Amount of Players:" + rs.rows.length  + " NickName:" + rs.rows.item(i).NAME + " Selected:" + rs.rows.item(i).GEWAEHLT + " Firstname:" + rs.rows.item(i).FIRSTNAME +" Lastname:" + rs.rows.item(i).LASTNAME  +" Email:" + rs.rows.item(i).EMAIL+" Notes:" +rs.rows.item(i).NOTES+" played:" + rs.rows.item(i).PLAYEDROUNDS +" TimePlayed:" + rs.rows.item(i).TIMEPLAYED+ " AveragePar:" +rs.rows.item(i).AVERAGEPAR  )
            nickname = rs.rows.item(i).NAME
            gewaehlt = rs.rows.item(i).GEWAEHLT
            firstname = rs.rows.item(i).FIRSTNAME
            lastname = rs.rows.item(i).LASTNAME
            email = rs.rows.item(i).EMAIL
            notes = rs.rows.item(i).NOTES
            pdga = rs.rows.item(i).PDGA
            averagepar = rs.rows.item(i).AVERAGEPAR
            roundplayed = rs.rows.item(i).PLAYEDROUNDS
            timeplayed = rs.rows.item(i).TIMEPLAYED

            var elapsed = timeplayed;
            var minutes = parseInt((elapsed / (1000 * 60)) % 60)
            var hours = parseInt((elapsed / (1000 * 60 * 60)) % 24);
            //var days = parseInt(elapsed / (1000*60*60*24));
            hours = (hours < 10) ? "0" + hours : hours;
            minutes = (minutes < 10) ? "0" + minutes : minutes;
            timeplayed = hours.toString() + "h " + minutes.toString() + "min "

            console.log(" ID:" + rs.rows.item(i).Id + " NickName:" + rs.rows.item(i).NAME + " Selected:" + rs.rows.item(i).GEWAEHLT + " Firstname:" + rs.rows.item(i).FIRSTNAME + " Lastname:" + rs.rows.item(i).LASTNAME + " Email:" + rs.rows.item(i).EMAIL + " Notes:" + rs.rows.item(i).NOTES + "PDGA: " + pdga + " played:" + rs.rows.item(i).PLAYEDROUNDS + " TimePlayed:" + timeplayed + " AveragePar:" + rs.rows.item(i).AVERAGEPAR)
        }
    })
}

function showCourses() {
    var course_id
    var coursename
    var baskets
    var totalpar
    var notes
    var played
    var bestscore
    var avgscore
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM courses');
        for (var i = 0; i < rs.rows.length; i++) {
            //DEBUG
            course_id = rs.rows.item(i).COURSE_ID
            coursename = rs.rows.item(i).COURSENAME
            baskets = rs.rows.item(i).BASKETS
            totalpar = rs.rows.item(i).TOTALPAR
            notes = rs.rows.item(i).NOTES
            played = rs.rows.item(i).PLAYED
            bestscore = rs.rows.item(i).BESTSCORE
            avgscore = rs.rows.item(i).AVGSCORE
            console.log(" COURSE_ID:" + course_id + " COURSENAME:" + coursename + " BASKETS:" + baskets + " TOTALPAR:" + totalpar + " NOTES:" + notes + " PLAYED:" + played + " BESTSCORE:" + bestscore + " AVGSCORE: " + avgscore)
        }
    })
}

function showBaskets() {
    var basket_id
    var basketnr
    var par
    var basketname
    var distance
    var mando
    var notes
    var course_id
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM baskets');
        for (var i = 0; i < rs.rows.length; i++) {
            //DEBUG
            basket_id = rs.rows.item(i).BASKET_ID
            basketnr = rs.rows.item(i).BASKETNR
            par = rs.rows.item(i).PAR
            basketname = rs.rows.item(i).BASKETNAME
            distance = rs.rows.item(i).DISTANCE
            mando = rs.rows.item(i).MANDO
            notes = rs.rows.item(i).NOTES
            course_id = rs.rows.item(i).COURSE_ID

            console.log(" BASKET_ID:" + basket_id + " BASKETNR:" + basketnr + " PAR:" + par + " BASKETNAME:" + basketname + " DISTANCE:" + distance + " MANDO:" + mando + " NOTES:" + notes + " COURSE_ID: " + course_id)
        }
    })
}

function showResultBasic() {
    var res_id
    var date
    var course_id
    var time_played
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM resultBasic');
        for (var i = 0; i < rs.rows.length; i++) {
            //DEBUG
            res_id = rs.rows.item(i).RES_ID
            date = rs.rows.item(i).DATE
            course_id = rs.rows.item(i).COURSE_ID
            time_played = rs.rows.item(i).TIME_PLAYED

            var elapsed = time_played;
            var minutes = parseInt((elapsed / (1000 * 60)) % 60)
            var hours = parseInt((elapsed / (1000 * 60 * 60)) % 24);
            //var days = parseInt(elapsed / (1000*60*60*24));
            hours = (hours < 10) ? "0" + hours : hours;
            minutes = (minutes < 10) ? "0" + minutes : minutes;
            time_played = hours.toString() + "h " + minutes.toString() + "min "

            console.log(" RES_ID:" + res_id + " DATE:" + date + " COURSE_ID:" + course_id + " TIME_PLAYED:" + time_played)
        }
    })
}

function showResultDetail() {
    var res_id
    var id
    var basket_id
    var playerpar
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM resultDetail');
        for (var i = 0; i < rs.rows.length; i++) {
            //DEBUG
            res_id = rs.rows.item(i).RES_ID
            id = rs.rows.item(i).Id
            basket_id = rs.rows.item(i).BASKED_ID
            playerpar = rs.rows.item(i).PLAYERPAR

            console.log(" RES_ID:" + res_id + " Id:" + id + " BASKED_ID:" + basket_id + " PLAYERPAR:" + playerpar)
        }
    })
}

function showEndResult() {
    var res_id
    var id
    var course_id
    var playerstotalpar
    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM endResult');
        for (var i = 0; i < rs.rows.length; i++) {
            //DEBUG
            res_id = rs.rows.item(i).RES_ID
            id = rs.rows.item(i).Id
            course_id = rs.rows.item(i).COURSE_ID
            playerstotalpar = rs.rows.item(i).PLAYERTOTALPAR
            console.log(" RES_ID:" + res_id + " Id:" + id + " COURSE_ID:" + course_id + " PLAYERTOTALPAR:" + playerstotalpar)
        }
    })
}

*/
