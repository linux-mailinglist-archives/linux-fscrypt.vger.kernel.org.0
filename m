Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CBA2B26F9
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 22:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKMVeJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 16:34:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgKMVeG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:06 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72BC622252;
        Fri, 13 Nov 2020 21:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605303245;
        bh=E2MgoTiDqhzAIGKvNyWv924nsIjAH2PD8FUSGQEU20I=;
        h=From:To:Cc:Subject:Date:From;
        b=BU0srkoVKcsnaSwB3nOsLKxw/ZI2MveSISAtd3cBfPuWNU85oS0h+fGRXyopgZTBH
         /jaDhN8wYVhvbbymgQD9PezP4Su3+spObctDO91PEegMQ++MkjB4EGMQNFttlYVK+D
         mlH48zYc3AVRAITMDRg75MU+6tkjZ3uQtCnvHgIM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Luca Boccassi <luca.boccassi@gmail.com>,
        Martijn Coenen <maco@android.com>,
        Paul Lawrence <paullawrence@google.com>
Subject: [fsverity-utils PATCH 0/2] fsverity-utils cleanups
Date:   Fri, 13 Nov 2020 13:33:12 -0800
Message-Id: <20201113213314.73616-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

These are the fsverity-utils updates for the kernel patchset
https://lkml.kernel.org/linux-fscrypt/20201113211918.71883-1-ebiggers@kernel.org.

I'll apply this after the kernel patches are upstreamed.

Eric Biggers (2):
  Upgrade to latest fsverity_uapi.h
  Rename "file measurement" to "file digest"

 NEWS.md                |  6 +++---
 README.md              | 20 ++++++++---------
 common/fsverity_uapi.h | 49 ++++++++++++++++++++++++++++++++++++++++++
 include/libfsverity.h  | 18 ++++++++--------
 lib/compute_digest.c   | 17 ---------------
 lib/sign_digest.c      | 15 +------------
 programs/cmd_digest.c  | 13 +++--------
 programs/cmd_measure.c |  2 +-
 programs/cmd_sign.c    |  2 +-
 programs/fsverity.c    |  4 ++--
 10 files changed, 79 insertions(+), 67 deletions(-)

-- 
2.29.2

