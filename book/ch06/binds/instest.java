import java.sql.*;
public class instest
{
   static public void main(String args[]) throws Exception
   {
	  System.out.println( "start" );
      DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
      Connection
         conn = DriverManager.getConnection
                ("jdbc:oracle:thin:@localhost:1521:ora11gr2",
                 "scott","tiger");
      conn.setAutoCommit( false );
      PreparedStatement pstmt =
          conn.prepareStatement
          ("insert into "+ args[0] + " (x) values(?)" );
      for( int i = 0; i < 25000; i++ )
      {
        pstmt.setInt( 1, i );
        pstmt.executeUpdate();
      }
      conn.commit();
      conn.close();
	  System.out.println( "done" );
   }
}

