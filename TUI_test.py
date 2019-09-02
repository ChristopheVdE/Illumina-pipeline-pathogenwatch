import curses
import npyscreen

# CUSTOM BUTTONS ==============================================================================================
# RUN APP -----------------------------------------------------------------------------------------------------


class Button_Run(npyscreen.ButtonPress):
    def whenPressed(self):
        self.parent.parentApp.switchForm('RUNNING')
# EXIT APP -----------------------------------------------------------------------------------------------------


class Button_Exit(npyscreen.ButtonPress):
    def whenPressed(self):
        self.parent.parentApp.switchForm(None)
# PREVIOUS FORM -----------------------------------------------------------------------------------------------


class Button_Previous(npyscreen.ButtonPress):
    def whenPressed(self):
        self.parent.parentApp.switchFormPrevious()
# SWITCH TO FORM: OPTIONAL INPUT -------------------------------------------------------------------------------


class Button(npyscreen.ButtonPress):
    def whenPressed(self):
        self.parent.parentApp.switchForm('OPTIONAL')
# SWITCH TO FORM: OPTIONAL INPUT -------------------------------------------------------------------------------


class Button_Info(npyscreen.ButtonPress):
    def whenPressed(self):
        self.parent.parentApp.switchForm('INFO')
# ==============================================================================================================

# FORMS =======================================================================================================
# FORM: REQUIRED INPUT ----------------------------------------------------------------------------------------


class input_main(npyscreen.FormBaseNewWithMenus, npyscreen.SplitForm):
    def create(self):
        # WIDGETS (INPUT) -------------------------------------------------------------------------------------
        self.myName = self.add(npyscreen.TitleText, name='Name')
        self.myDepartment = self.add(npyscreen.TitleSelectOne, scroll_exit=True, max_height=3, name='Department', values=[
                                     'Department 1', 'Department 2', 'Department 3'])
        # LINE ------------------------------------------------------------------------------------------------
        self.draw_line_at = 1
        # BUTTONS ---------------------------------------------------------------------------------------------
        self.optional_input = self.add(Button, name='OPTIONAL SETTINGS')
        self.optional_input = self.add(Button, name='INFO')
        self.run_app = self.add(Button_Run, name='RUN')
        self.exit = self.add(Button_Exit, name='EXIT')
        # MENUS -----------------------------------------------------------------------------------------------
        self.menu = self.new_menu(name='MENU')

# FORM: OPTIONAL INPUT ----------------------------------------------------------------------------------------


class input_optional(npyscreen.FormBaseNew):
    def create(self):
        # self.show_atx = 20
        # self.show_aty = 5
        # WIDGETS (INPUT) -------------------------------------------------------------------------------------
        self.test = self.add(npyscreen.TitleText, name='test')
        # BUTTONS ---------------------------------------------------------------------------------------------
        self.previous = self.add(
            Button_Previous, name='Previous', relx=3, rely=4)
        self.run_app = self.add(Button_Run, name='RUN', relx=15, rely=4)
        self.exit = self.add(Button_Exit, name='EXIT',)

# FORM: RUNNING ------------------------------------------------------------------------------------------------


class running(npyscreen.FormBaseNew):
    def create(self):
        # STATUS ----------------------------------------------------------------------------------------------
        self.status_box = self.add(
            npyscreen.BoxBasic, name='Status', max_height=5, max_width=115, editable=False)
        self.previous = self.add(
            Button_Previous, name='Previous', relx=3, rely=4)
        self.run_app = self.add(Button_Run, name='RUN', relx=15, rely=4)
        self.exit = self.add(Button_Exit, name='EXIT', relx=25, rely=4)
        # SAMPLES ---------------------------------------------------------------------------------------------
        self.sample_box = self.add(
            npyscreen.BoxBasic, name='Samples', rely=7, max_height=40, max_width=25, editable=False)
        samples = ['sample1', 'sample2', 'longname qsjdghqljfqslq']
        self.sample_select = self.add(npyscreen.SelectOne, values=samples,
                                      relx=4, rely=9, max_width=20, max_height=35, scroll_exit=True)

        # for i in samples:
        #     self.i = self.add( npyscreen.Button, name = i)
        # RESULTS ----------------------------------------------------------------------------------------------
        self.output_box = self.add(npyscreen.BoxBasic, name='Output',
                                   relx=30, rely=7, max_height=40, max_width=87, editable=False)

# ==============================================================================================================

# MENU'S=======================================================================================================
# INFO: MAIN MENU ---------------------------------------------------------------------------------------------


class menu(npyscreen.NewMenu):
    def create(self):
        self.addItem(text="test")
# INFO: SUB MENU ----------------------------------------------------------------------------------------------
# class submenu():
# ==============================================================================================================

# APPLICATION WRAPPER =========================================================================================


class App(npyscreen.NPSAppManaged):
    def onStart(self):
        self.addForm('MAIN', input_main, name='MAIN')
        self.addForm('OPTIONAL', input_optional, name='OPTIONAL')
        self.addForm('RUNNING', running, name='RUNNING ANALYSIS')
# =============================================================================================================


# EXECUTE APLICATION ==========================================================================================
if __name__ == '__main__':
    TestApp = App().run()
    print("All objects, baby.")
# =============================================================================================================
