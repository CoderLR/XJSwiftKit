//
//  YSRegexTool.swift
//  LeiFengHao
//
//  Created by xj on 2021/10/21.
//

import Foundation

/* 正则字符详解
 \
 将下一个字符标记为一个特殊字符、或一个原义字符、或一个 向后引用、或一个八进制转义符。例如，'n' 匹配字符 "n"。'\n' 匹配一个换行符。序列 '\\' 匹配 "\" 而 "\(" 则匹配 "("。
 
 ^
 匹配输入字符串的开始位置。如果设置了 RegExp 对象的 Multiline 属性，^ 也匹配 '\n' 或 '\r' 之后的位置。
 
 $
 匹配输入字符串的结束位置。如果设置了RegExp 对象的 Multiline 属性，$ 也匹配 '\n' 或 '\r' 之前的位置。
 
 *
 匹配前面的子表达式零次或多次。例如，zo* 能匹配 "z" 以及 "zoo"。* 等价于{0,}。
 
 +
 匹配前面的子表达式一次或多次。例如，'zo+' 能匹配 "zo" 以及 "zoo"，但不能匹配 "z"。+ 等价于 {1,}。
 
 ?
 匹配前面的子表达式零次或一次。例如，"do(es)?" 可以匹配 "do" 或 "does" 。? 等价于 {0,1}。
 
 {n}
 n 是一个非负整数。匹配确定的 n 次。例如，'o{2}' 不能匹配 "Bob" 中的 'o'，但是能匹配 "food" 中的两个 o。
 
 {n,}
 n 是一个非负整数。至少匹配n 次。例如，'o{2,}' 不能匹配 "Bob" 中的 'o'，但能匹配 "foooood" 中的所有 o。'o{1,}' 等价于 'o+'。'o{0,}' 则等价于 'o*'。
 
 {n,m}
 m 和 n 均为非负整数，其中n <= m。最少匹配 n 次且最多匹配 m 次。例如，"o{1,3}" 将匹配 "fooooood" 中的前三个 o。'o{0,1}' 等价于 'o?'。请注意在逗号和两个数之间不能有空格。
 
 ?
 当该字符紧跟在任何一个其他限制符 (*, +, ?, {n}, {n,}, {n,m}) 后面时，匹配模式是非贪婪的。非贪婪模式尽可能少的匹配所搜索的字符串，而默认的贪婪模式则尽可能多的匹配所搜索的字符串。例如，对于字符串 "oooo"，'o+?' 将匹配单个 "o"，而 'o+' 将匹配所有 'o'。
 
 .
 匹配除换行符（\n、\r）之外的任何单个字符。要匹配包括 '\n' 在内的任何字符，请使用像"(.|\n)"的模式。
 
 x|y
 匹配 x 或 y。例如，'z|food' 能匹配 "z" 或 "food"。'(z|f)ood' 则匹配 "zood" 或 "food"。
 
 [xyz]
 字符集合。匹配所包含的任意一个字符。例如， '[abc]' 可以匹配 "plain" 中的 'a'。
 
 [^xyz]
 负值字符集合。匹配未包含的任意字符。例如， '[^abc]' 可以匹配 "plain" 中的'p'、'l'、'i'、'n'。
 
 [a-z]
 字符范围。匹配指定范围内的任意字符。例如，'[a-z]' 可以匹配 'a' 到 'z' 范围内的任意小写字母字符。
 
 [^a-z]
 负值字符范围。匹配任何不在指定范围内的任意字符。例如，'[^a-z]' 可以匹配任何不在 'a' 到 'z' 范围内的任意字符。
 
 \d
 匹配一个数字字符。等价于 [0-9]。
 
 \D
 匹配一个非数字字符。等价于 [^0-9]。
 
 \w
 匹配字母、数字、下划线。等价于'[A-Za-z0-9_]'。
 
 \W
 匹配非字母、数字、下划线。等价于 '[^A-Za-z0-9_]'。
 */

// MARK:- 校验字符的表达式
public enum YSRegexCharacterType: String {
    /// 汉字
    case type1 = "^[\\u4e00-\\u9fa5]{0,}$"
    /// 英文和数字 ^[A-Za-z0-9]+$ 或 ^[A-Za-z0-9]{4,40}$
    case type2 = "^[A-Za-z0-9]{4,40}$"
    /// 长度为3-20的所有字符
    case type3 = "^.{3,20}$"
    /// 由26个英文字母组成的字符串
    case type4 = "^[A-Za-z]+$"
    /// 由26个大写英文字母组成的字符串
    case type5 = "^[A-Z]+$"
    /// 由26个小写英文字母组成的字符串
    case type6 = "^[a-z]+$"
    /// 由数字和26个英文字母组成的字符串
    case type7 = "^[A-Za-z0-9]+$"
    /// 由数字、26个英文字母或者下划线组成的字符串 ^\w+$ 或 ^\w{3,20}$
    case type8 = "^\\w+$"
    /// 中文、英文、数字包括下划线
    case type9 = "^[\\u4E00-\\u9FA5A-Za-z0-9_]+$"
    /// 中文、英文、数字但不包括下划线等符号 ^[\u4E00-\u9FA5A-Za-z0-9]+$ 或 ^[\u4E00-\u9FA5A-Za-z0-9]{2,20}$
    case type10 = "^[\\u4E00-\\u9FA5A-Za-z0-9]+$"
    /// 可以输入含有^%&',;=?$\"等字符
    case type11 = "[^%&',;=?$\\x22]+"
    /// 禁止输入含有~的字符
    case type12 = "[^~\\x22]+"
}

// MARK:- 校验数字的表达式
public enum JKRegexDigitalType: String {
    /// 数字
    case type1 = "^[0-9]*$"
    /// 零和非零开头的数字
    case type2 = "^(0|[1-9][0-9]*)$"
    /// 非零开头的最多带两位小数的数字
    case type3 = "^([1-9][0-9]*)+(\\.[0-9]{1,2})?$"
    /// 非零的正整数：^[1-9]\d*$ 或 ^([1-9][0-9]*){1,3}$ 或 ^\+?[1-9][0-9]*$
    case type4 = "^[1-9]\\d*$"
    /// 非零的负整数：^\-[1-9][]0-9"*$ 或 ^-[1-9]\d*$
    case type5 = "^-[1-9]\\d*$"
    /// 非负整数：^\d+$ 或 ^[1-9]\d*|0$
    case type6 = "^\\d+$"
    /// 非正整数：^-[1-9]\d*|0$ 或 ^((-\d+)|(0+))$
    case type7 = "^((-\\d+)|(0+))$"
    /// 非负浮点数：^\d+(\.\d+)?$ 或 ^[1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0$
    case type8 = "^\\d+(\\.\\d+)?$"
    /// 非正浮点数：^((-\d+(\.\d+)?)|(0+(\.0+)?))$ 或 ^(-([1-9]\d*\.\d*|0\.\d*[1-9]\d*))|0?\.0+|0$
    case type9 = "^((-\\d+(\\.\\d+)?)|(0+(\\.0+)?))$"
    /// 正浮点数：^[1-9]\d*\.\d*|0\.\d*[1-9]\d*$ 或 ^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$
    case type10 = "^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$"
    /// 负浮点数：^-([1-9]\d*\.\d*|0\.\d*[1-9]\d*)$ 或 ^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$
    case type11 = "^-([1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*)$"
    /// 浮点数：^(-?\d+)(\.\d+)?$ 或 ^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0)$
    case type12 = "^(-?\\d+)(\\.\\d+)?$"
    /// 手机号
    case type13 = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199)\\d{8}$"
}

// MARK:- 一、正则匹配的使用
public struct YSRegexTool {

    // MARK: 1.1、通用匹配
    /// 通用匹配
    /// - Parameters:
    ///   - input: 匹配的字符串
    ///   - pattern: 匹配规则
    /// - Returns: 返回匹配的结果
    public static func match(_ input: String, pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        guard let regex: NSRegularExpression = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
    
    // MARK: 1.2、获取匹配的Range
    /// 获取匹配的Range
    /// - Parameters:
    ///   - input: 匹配的字符串
    ///   - pattern: 匹配规则
    /// - Returns: 返回匹配的[NSRange]结果
    public static func matchRange(_ input: String, pattern: String, options: NSRegularExpression.Options = []) -> [NSRange] {
        guard let regex: NSRegularExpression = try? NSRegularExpression(pattern: pattern, options: options) else {
            return []
        }
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        guard matches.count > 0 else {
            return []
        }
        return matches.map { value in
            value.range
        }
    }
    
    // MARK: 1.3、验证邮箱是否合法
    /// 验证邮箱是否合法
    /// - Parameters:
    ///   - emailString: 邮箱
    ///   - pattern: 匹配规则
    /// - Returns: 返回结果
    public static func validateEmail(_ emailString: String, pattern: String = "^([a-z0-9A-Z]+[-_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$") -> Bool {
        return match(emailString, pattern: pattern)
    }
    
    // MARK: 1.4、 判断是否是有效的手机号码
    ///  判断是否是有效的手机号码
    /// - Parameter telNum: 手机号码
    /// - Returns: 返回结果
    public static func validateTelephoneNumber(_ telNum: String, pattern: String = JKRegexDigitalType.type13.rawValue) -> Bool {
        return match(telNum, pattern: pattern)
    }
    
    // MARK: 1.5、正则匹配用户姓名
    /// 正则匹配用户姓名
    /// - Parameter userName: 用户姓名
    /// - Returns: 匹配结果
    public static func validateUserName(_ userName: String) -> Bool {
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch: Bool = pred.evaluate(with: userName)
        return isMatch
    }
    
    // MARK: 1.6、正则匹配用户身份证号15或18位
    /// 正则匹配用户身份证号15或18位
    /// - Parameter userIdCard: 用户身份证号15或18位
    /// - Returns: 匹配结果
    public static func validateUserIdCard(_ userIdCard: String) -> Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch: Bool = pred.evaluate(with: userIdCard)
        return isMatch
    }
    
    // MARK: 1.7、 判断是否是数字
    ///  判断是数字
    /// - Parameter text: 字符串
    /// - Returns: 返回结果
    public static func validateNumber(_ text: String, pattern: String = JKRegexDigitalType.type1.rawValue) -> Bool {
        return match(text, pattern: pattern)
    }
}
