   M S B A M L   `   `   `  ����N  JInnovalutaion_Admin, Version=1.0.0.0, Culture=neutral, PublicKeyToken=nullE'clr-namespace:Innovalutaion_Admin.PagesInnovalutaion_Admin.Pages  5      1    +Innovalutaion_Admin.Pages.CreatePatientPage   5      W SPresentationCore, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35e aSystem.Windows.Controls.Ribbon, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089R NWindowsBase, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5      R NSystem.Xaml, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5      Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5      @d2http://schemas.microsoft.com/expression/blend/2008     5      9local'clr-namespace:Innovalutaion_Admin.Pages     5        N� Title$  CreatePatientPage��5	      .��5      � 
������� � RowDefinitions 5   
   �� 5      $
��0.4* �6   �� 5      .+�5   
   �� $!��Create Patient Account Page��6   $��22(�66   $
��Bold"�6D   $��Center=�6V   $��0,36,0,0q�6s   $	��Top=�6�   � 5   
   $��1��6    � ColumnDefinitions 5      �� 5      $
��0.5* �6#   �� 5      $
��0.5* �6#   .+�5      �� $��
First Name��6   $
��Left=�6)   $��	80,40,0,0q�6D   $	��Top=�6W   �� 5      -   5         ��Name$ firstNameTextBox��5      $
��Left=�60   $��	85,65,0,0q�6K    �� TextWrapping$
 Wrap=�6^   $�� ��6r   $	��Top=�6z   $	��120��6�   �� 5      $��	Last Name��6   $
��Left=�6(   $��
80,118,0,0q�6C   $	��Top=�6W   �� 5      -   5        $ lastNameTextBox��5      $
��Left=�6/   $	��Top=�6J   $��
85,143,0,0q�6b   $�� ��6v   $	��120��6~   �� 5      -   5         ��Name$ submitButton��5      $��Submit��6+   $��Center=�6<   $��	0,255,0,0q�6Y   $	��Top=�6l   $��23��6�   $��56��6�   6�   � 5!      $��1��6   .+�5"      �� $��Username��6   $
��Left=�6+   $	��Top=�6F   $��	80,20,0,0q�6^   �� 5#      -   5        $ usernameTextBox��5#      $
��Left=�63   $	��Top=�6N   $	��120��6f   $��	85,45,0,0q�6r   �� 5%      $��Password��6   $
��Left=�6+   $	��Top=�6F   $��	80,80,0,0q�6^   �� 5&      -   5        $ passwordBox1��5&      $
��Left=�60   $	��Top=�6K   $��
85,105,0,0q�6c   $	��120��6w   �� 5(      $��Confirm Password��6   $
��Left=�63   $	��Top=�6N   $��
80,145,0,0q�6f   �� 5)      -   5        $ passwordBox2��5)      $
��Left=�60   $	��Top=�6K   $��
85,170,0,0q�6c   $	��120��6w   5*      5.      50      51      