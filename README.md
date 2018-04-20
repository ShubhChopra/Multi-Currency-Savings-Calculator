# Multi-Currency-Savings-Calculator

## I made this application for my personl use of looking at the current exchange rate and checking my current total savings overseas with interest calculated in current exchange rate. I am using free Fixer api to get the current exchnge rates.

### During making this application I came across a log of techniques that can be very useful in making attactive iOS application and are surprisingly easy to implement. I would like to discuss this with the help of images:

[![Demo Vid](http://img.youtube.com/vi/nPXuqBEixL4/0.jpg)](http://www.youtube.com/watch?v=nPXuqBEixL4)

1. <p align = "center"> <img src=https://github.com/ShubhChopra/Multi-Currency-Savings-Calculator/blob/master/imgs/img1.png width="200"> </p>

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

```
func textViewDidChange(_ inputTextVal: UITextView) {
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

2. <p align = "center"> <img src=https://github.com/ShubhChopra/Multi-Currency-Savings-Calculator/blob/master/imgs/img2.png width="200"> </p>

For this section in learning about HTTP protocol handling in swift I refered to https://blog.apoorvmote.com/fetch-exchange-rate-internet-api-ios-swift/ .


3.  <p align = "center"> <img src=https://github.com/ShubhChopra/Multi-Currency-Savings-Calculator/blob/master/imgs/img3.png width="200"> </p>

For this section, to hold the data we first need a container class: 
`Savings.swift`
Then a custom table view cell
`SavingsTableViewCell.swift`
And the magic happens in fuctions below in `SavingTableViewController.swift` file.

```override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

```

There is a really good tutorial on how to design the floating cards type table view here 
https://www.youtube.com/watch?v=ZEuoaTF1bok

4. <p align = "center"> <img src=https://github.com/ShubhChopra/Multi-Currency-Savings-Calculator/blob/master/imgs/img4.png width="200"> </p>

No fun here!
