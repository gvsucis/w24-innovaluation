   M S B A M L   `   `   `  ����N  JInnovalutaion_Admin, Version=1.0.0.0, Culture=neutral, PublicKeyToken=nullE'clr-namespace:Innovalutaion_Admin.PagesInnovalutaion_Admin.Pages  5      /    )Innovalutaion_Admin.Pages.PatientDataPage   5      W SPresentationCore, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35e aSystem.Windows.Controls.Ribbon, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089R NWindowsBase, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5      R NSystem.Xaml, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5      Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5      @d2http://schemas.microsoft.com/expression/blend/2008     5      9local'clr-namespace:Innovalutaion_Admin.Pages     5        N� Title$  PatientDataPage��5	      .��5      � 
������� � RowDefinitions 5   
   �� 5      $
��0.3* �6   �� 5      .+�5   
   �� $��0��6   $��Patient Info��6   $��Center=�64   $��Center=�6Q   $
��36pt(�6l   $
��Bold"�6|   &   System.Windows.Controls.DataGrid  5   
   -   5          Name$ patientGridView��5      $��1��6,   $��75, 35, 75, 105q�6:   $
��Auto=�6S   $
��Auto=�5         
IsReadOnly$
 True��6s    � 	Resources 5      )  #System.Windows.Controls.DataGridRow �� 
TargetType��%E   '        �� 5      "  6   .�5      -   5        5      5         Columns 5      0  *System.Windows.Controls.DataGridTextColumn  5      ,  &System.Windows.Controls.DataGridColumn   Header$ username��6%      Width5  /System.Windows.Controls.DataGridLengthConverter$	 100 6T   1  +System.Windows.Controls.DataGridBoundColumn	   Binding	 67   �� *
username+6T     5      $
 uuid��6%   $	 100 6L   	 63   �� *uuid+6L     5       $ dateCreated��6%   $	 100 6Z   	 6:   �� *dateCreated+6Z     5!      $ WindowBegins��6%   $	 100 6\   	 6;   �� *twoDayWindow+6\     5"      $ 
windowEnds��6%   $	 100 6\   	 69   �� *threeDayWindow+6\     5#      $ initialPhotoTaken��6%   $	 100 6i   	 6@   �� *hasTakenInitialPhoto+6i     5$      $ followupTaken��6%   $	 100 6f   	 6<   �� *hasTakenFollowUpPhoto+6f     5%      $ QuestionnaireTaken��6%   $	 100 6l   	 6A   �� *questionnaireCompleted+6l   5'      5)      5*      