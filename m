Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C183CCA56
	for <lists+linux-fscrypt@lfdr.de>; Sun, 18 Jul 2021 21:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhGRTL3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 18 Jul 2021 15:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhGRTL3 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 18 Jul 2021 15:11:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 799AF61186;
        Sun, 18 Jul 2021 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626635310;
        bh=fxx6tMa0qpX2JkVrw4gb1C02TNGJC/HUBh5Oi7cLVlI=;
        h=From:To:Cc:Subject:Date:From;
        b=p583c2fAjjvKm4rv0MAEDuhETBFdzYYeKELBs4uqgYvf9b4LS59KFtgEkXHhuBmFE
         TfUndxXcmcqv7sRcbjScnoYkCHxwIQIuw4pS4SR2BwSUlbJ9ag88E8xugXk3hUu2GW
         ofq3aAxCvG8RWQbSNnBcfFQemk2aqyVzWOjlxr93io2qLqDiUnkpbgYqATmynxjFkC
         6yzmGb8WJd7JZ/IRHY1zg8aDu/VTtbWYTgH2DPq38LxwR3whRCD724i/Gcbs82bcdy
         w6k5eV/OdE1nrXSpF5EyHdEs7/JUuRUQo5wtlxxmQKwJrkV/fsFFxiFENn3QMDOxjX
         BHROY78lsgZCw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 0/3] xfstests: fscrypt no-key name updates
Date:   Sun, 18 Jul 2021 14:06:55 -0500
Message-Id: <20210718190658.61621-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series cleans up handling of no-key names in the encryption tests.

Eric Biggers (3):
  generic: update encryption tests to use term "no-key names"
  common/encrypt: add helper function for filtering no-key names
  common/encrypt: accept '-' character in no-key names

 common/encrypt        | 20 +++++++++++++++++++
 tests/generic/397     | 12 +++++------
 tests/generic/419     |  6 +++---
 tests/generic/419.out |  2 +-
 tests/generic/421     |  8 ++++----
 tests/generic/429     | 46 ++++++++++++++++++++-----------------------
 tests/generic/429.out | 22 ++++++++++-----------
 7 files changed, 66 insertions(+), 50 deletions(-)


base-commit: 623b4ea4082b8be71acaf261435d33fa4488993a
-- 
2.32.0

