Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC971E4FED
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 May 2020 23:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgE0VRP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 May 2020 17:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgE0VRP (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 May 2020 17:17:15 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45FEF207E8;
        Wed, 27 May 2020 21:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590614235;
        bh=Bnk38Eo92VF+T3djq9FzBVQ1j6ScWep8mmWpaFR4UiI=;
        h=From:To:Cc:Subject:Date:From;
        b=OPeCm4az0tThJ1NjxTb5SqT8kwZ38nXbntNKpdsJDg1jvGHOPub9bjbF6ZzaBw8fT
         U+dKNFgtk8oDd9ILxmLFsrzMNfhzlpy5+AxRBi8nMEHBFwqjRNhKrGIp7CBrLva5pv
         /c+64FnVZPTidikx0SMBcimug6Cmv88Qe2FVaLLc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-fscrypt@vger.kernel.org
Subject: [xfstests-bld PATCH] build-all: update rule to build fsverity-utils
Date:   Wed, 27 May 2020 14:16:42 -0700
Message-Id: <20200527211642.122200-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

To match the usual convention, the fsverity-utils Makefile now takes a
PREFIX variable which defaults to /usr/local.

But xfstests-bld wants PREFIX=/usr, so set that.

Also don't explicitly build the 'all' target, since 'install' depends on
it already.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 build-all | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/build-all b/build-all
index 0122628..572edfa 100755
--- a/build-all
+++ b/build-all
@@ -290,7 +290,7 @@ if test -z "$SKIP_FSVERITY"; then
     build_start "fsverity"
     (cd fsverity; \
      ver=$(git describe --always --dirty); echo "fsverity	$ver ($(git log -1 --pretty=%cD))" > ../fsverity.ver ; \
-     $MAKE_CLEAN ; make $J all ; make install DESTDIR=$DESTDIR)
+     $MAKE_CLEAN ; make $J install DESTDIR=$DESTDIR PREFIX=/usr)
 fi
 
 if test -z "$SKIP_IMA_EVM_UTILS" ; then
-- 
2.26.2

