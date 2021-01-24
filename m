Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCF5301C7E
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jan 2021 15:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbhAXOJh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 24 Jan 2021 09:09:37 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:27633 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbhAXOJg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 24 Jan 2021 09:09:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1611497203;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=Y189rnv2QfUxhT1OemVIrE8/eQASWIoiVDAuFGKd78c=;
        b=Ko+nN1D7CEDfucvwiaFEisPLQKxG3kEGrJqur6G03Q2Ywk8OEP3NLzIyMLbA55RXgv
        TKvcANrsazw9D08kgS1eDoKT43wwZvdfrFP6/tGuKuMQYblSOPTUcuyVdEvoVuYH8TgC
        HsmebSwyR4HHC0h0Mv3PR2u3trpiy0JyU1CAqIjD/mBNFkjsoEbJlvAoRSW1ILPW0oq5
        lUsNuxbxzkdX5M6E/Qy/e9cC+L3e4FcZZeMJBhYHa/vNpRbbLCrpYnnkK5x/A13BIOHw
        nL9S26Bz4cfbt2KqO3Lo+0SENX7y+Z98UHklEcXdAVJ4QZ++BeFQ1guOoKJw3Bw6AD4u
        3L8w==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZI/ScIzb9"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x0OE6feiU
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 24 Jan 2021 15:06:41 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     ebiggers@kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
        linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        simo@redhat.com
Subject: [PATCH v2 7/7] fs: HKDF - remove duplicate memory clearing
Date:   Sun, 24 Jan 2021 15:04:50 +0100
Message-ID: <8714658.CDJkKcVGEf@positron.chronox.de>
In-Reply-To: <1772794.tdWV9SEqCh@positron.chronox.de>
References: <1772794.tdWV9SEqCh@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The clearing of the OKM memory buffer in case of an error is already
performed by the HKDF implementation crypto_hkdf_expand. Thus, the
code clearing is not needed any more in the file system code base.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 fs/crypto/hkdf.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index ae236b42b1f0..c48dd8ca3a46 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -102,13 +102,10 @@ int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 		.iov_base = (u8 *)info,
 		.iov_len = infolen,
 	} };
-	int err = crypto_hkdf_expand(hkdf->hmac_tfm,
-				     info_iov, ARRAY_SIZE(info_iov),
-				     okm, okmlen);
 
-	if (unlikely(err))
-		memzero_explicit(okm, okmlen); /* so caller doesn't need to */
-	return err;
+	return crypto_hkdf_expand(hkdf->hmac_tfm,
+				  info_iov, ARRAY_SIZE(info_iov),
+				  okm, okmlen);
 }
 
 void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf)
-- 
2.26.2




