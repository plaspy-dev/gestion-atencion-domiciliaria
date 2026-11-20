namespace SDG.Web.UI.WebControls
{
	partial class ConfigureDataSource
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null)) {
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.lInstructions = new System.Windows.Forms.Label();
			this.label1 = new System.Windows.Forms.Label();
			this.ddlTypes = new System.Windows.Forms.ComboBox();
			this.ddlMethods = new System.Windows.Forms.ComboBox();
			this.bOK = new System.Windows.Forms.Button();
			this.bCancel = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// lInstructions
			// 
			this.lInstructions.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.lInstructions.Location = new System.Drawing.Point(12, 9);
			this.lInstructions.Name = "lInstructions";
			this.lInstructions.Size = new System.Drawing.Size(505, 18);
			this.lInstructions.TabIndex = 0;
			this.lInstructions.Text = "Choose a type:";
			// 
			// label1
			// 
			this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.label1.Location = new System.Drawing.Point(12, 79);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(505, 18);
			this.label1.TabIndex = 1;
			this.label1.Text = "Choose a method:";
			// 
			// ddlTypes
			// 
			this.ddlTypes.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.ddlTypes.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.ddlTypes.FormattingEnabled = true;
			this.ddlTypes.Location = new System.Drawing.Point(12, 30);
			this.ddlTypes.Name = "ddlTypes";
			this.ddlTypes.Size = new System.Drawing.Size(502, 21);
			this.ddlTypes.TabIndex = 2;
			this.ddlTypes.SelectedIndexChanged += new System.EventHandler(this.ddlTypes_SelectedIndexChanged);
			// 
			// ddlMethods
			// 
			this.ddlMethods.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.ddlMethods.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.ddlMethods.Enabled = false;
			this.ddlMethods.FormattingEnabled = true;
			this.ddlMethods.Location = new System.Drawing.Point(12, 100);
			this.ddlMethods.Name = "ddlMethods";
			this.ddlMethods.Size = new System.Drawing.Size(502, 21);
			this.ddlMethods.TabIndex = 3;
			this.ddlMethods.SelectedIndexChanged += new System.EventHandler(this.ddlMethods_SelectedIndexChanged);
			// 
			// bOK
			// 
			this.bOK.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.bOK.DialogResult = System.Windows.Forms.DialogResult.OK;
			this.bOK.Enabled = false;
			this.bOK.Location = new System.Drawing.Point(182, 143);
			this.bOK.Name = "bOK";
			this.bOK.Size = new System.Drawing.Size(75, 23);
			this.bOK.TabIndex = 4;
			this.bOK.Text = "Accept";
			this.bOK.UseVisualStyleBackColor = true;
			this.bOK.Click += new System.EventHandler(this.bOK_Click);
			// 
			// bCancel
			// 
			this.bCancel.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.bCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.bCancel.Location = new System.Drawing.Point(272, 143);
			this.bCancel.Name = "bCancel";
			this.bCancel.Size = new System.Drawing.Size(75, 23);
			this.bCancel.TabIndex = 5;
			this.bCancel.Text = "Cancel";
			this.bCancel.UseVisualStyleBackColor = true;
			// 
			// ConfigureDataSource
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(529, 182);
			this.ControlBox = false;
			this.Controls.Add(this.bCancel);
			this.Controls.Add(this.bOK);
			this.Controls.Add(this.ddlMethods);
			this.Controls.Add(this.ddlTypes);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.lInstructions);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "ConfigureDataSource";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Configure Data Source";
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.Label lInstructions;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.ComboBox ddlTypes;
		private System.Windows.Forms.ComboBox ddlMethods;
		private System.Windows.Forms.Button bOK;
		private System.Windows.Forms.Button bCancel;
	}
}