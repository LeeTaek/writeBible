////
////  SettingRealmRepository.swift
////  Bible
////
////  Created by openobject on 2023/07/20.
////  Copyright © 2023 leetaek. All rights reserved.
////

import Foundation
 
struct SettingRealmRepository: Repository {
  typealias value = SettingVO
  
  init() { }
  
  public func create(data: SettingVO) async throws {
    let dto = toDTO(vo: data)
    do {
      try await SettingRealmDataSrouce.shared.create(data: dto)
    } catch {
      Log.debug(error)
    }
  }
  
  func read() async throws -> SettingVO {
    do {
      let vo = try await SettingRealmDataSrouce.shared.read().toStore()
      return vo
    } catch {
      Log.debug(error)
      return SettingVO.defaultValue
    }
  }
  
  func update(data: SettingVO) async throws -> SettingVO {
    let dto = toDTO(vo: data)
    do {
      let vo = try await SettingRealmDataSrouce.shared.update(data: dto).toStore()
      return vo
    } catch {
      Log.debug(error)
      return data
    }
  }
  
  func delete(data: SettingVO) async throws {
    let dto = toDTO(vo: data)
    do {
      try await SettingRealmDataSrouce.shared.delete(data: dto)
    } catch {
      Log.debug(error)
    }
  }
  
  
  func toDTO(vo: SettingVO) -> SettingRealmDTO {
    return .init(lineSpace: vo.lineSpace,
                 fontSize: vo.fontSize,
                 traking: vo.traking,
                 baseLineHeight: vo.baseLineHeight,
                 font: vo.font.rawValue
    )
  }
  
}
