# Multi-Currency-Savings-Calculator

## I made this application for my personl use of looking at the current exchange rate and checking my current total savings overseas with interest calcualted in current exchange rate. I am using free Fixer api to get the current excahnge rates.

### During making this application I came across a log of techniques that can be very useful in making attactive iOS application and are surprisingly easy to implement. I would like to discuss this with the help of images:

1. <img src=https://github.com/ShubhChopra/Multi-Currency-Savings-Calculator/blob/master/imgs/img1.png width="200"> 

This is the main screen where you can check the current excahnge rates based on selected currencies. For selecting currency I decided to use 2 different types of character set. For the base current I am using a vertical UIpicker and currency symbols and for the exchange currency, I am using 3 char curreny short code and a horizontal UIPicker. 
Cool way to change a vertical picker to horizontal one:

```
self.selectedExchangeRatePickerYComponent = self.selectedExchangeRatePicker.frame.origin.y
                self.selectedExchangeRatePickerXComponent = self.selectedExchangeRatePicker.frame.origin.x
                self.rotationAngle = (-90 * (.pi / 180) ) as CGFloat
                self.selectedExchangeRatePicker.transform = CGAffineTransform(rotationAngle: self.rotationAngle  )
                self.selectedExchangeRatePicker.frame = CGRect.init(x: self.selectedExchangeRatePickerXComponent - 25, y: self.selectedExchangeRatePickerYComponent, width: self.selectedExchangeRatePicker.frame.height + 50, height:self.selectedExchangeRatePicker.frame.width)
```
I also had to change the height of each row so that the previous and next rows doesn't show up in the main screen:

```
func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if(pickerView == selectedExchangeRatePicker) {
            return 200
        }
        else{
            return 150
        }
    }
```
The exchange value `1.0` is a label so another issue I faced was dealing with changing the label values like I am textview but without the ugly cursur and white background, so I added a text view on top of the label (background, text, tint all clear color) and added the code snippit below to changed the label valued based on the invisible textview.

```func textViewDidChange(_ inputTextVal: UITextView) {
        selectedCurrencyCode.text = inputTextVal.text
        
    }
 ```
Lastly was the issue with having to dismiss the keyboard after I am done editing the lable and since I am using a decimal keyboad, it had no returned button and so I made a button programically:

```
//init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: Selector("doneButtonAction"))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.inputTextVal.inputAccessoryView = toolbar
        
        func doneButtonAction() {
        self.view.endEditing(true)
        self.selectedCurrencyRatePicker.reloadAllComponents()
        self.selectedExchangeRatePicker.reloadAllComponents()
        loadDataFromInternet()
        self.rotationAngle = (-90 * (.pi / 180) ) as CGFloat
        self.selectedExchangeRatePicker.transform = CGAffineTransform(rotationAngle: self.rotationAngle  )
        self.selectedExchangeRatePicker.frame = CGRect.init(x: self.selectedExchangeRatePickerXComponent - 25, y: self.selectedExchangeRatePickerYComponent, width: self.selectedExchangeRatePicker.frame.height + 50, height:self.selectedExchangeRatePicker.frame.width)
        
    }
```

2. <img src=https://github.com/ShubhChopra/Multi-Currency-Savings-Calculator/blob/master/imgs/img2.png width="200">
3. <img src=https://github.com/ShubhChopra/Multi-Currency-Savings-Calculator/blob/master/imgs/img3.png width="200">
4. <img src=https://github.com/ShubhChopra/Multi-Currency-Savings-Calculator/blob/master/imgs/img4.png width="200">

