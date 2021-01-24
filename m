Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAFB301C94
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jan 2021 15:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbhAXOK0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 24 Jan 2021 09:10:26 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:21964 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbhAXOJi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 24 Jan 2021 09:09:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1611497205;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=Fyc0rzVotIOUtUm7++3lcJ+qWnVjlyTyBLMUYptLgRk=;
        b=R5qniK8GEUCy+q1km8pHfRA3ZfmLr+g/RtQOxgxGrUG31E+a94HlTLQqPa4PhbvdVO
        8IMgkD+SnbP85DqsK8rVCbHQGfM/w94dkKzhFk4vS9qZPYFJr5EoUaJFgL9czZxAOtUN
        osKIQlZgsxcuRzuZoMdb/F1Tav/te7zODIapdp/9sJV0NhTaDRbqNAQF1poFrc0WbKqI
        l4jR88czOkLizwOT2XCKtSF4hjGPX65aEN3X3xTiM2dcgPL2HbqmVUSS4MABFKtXJQef
        WJYNluT5SXZsO2JRx8meWbgDBk7Q1XrcikwhafslEFpFJqm05wKiRtMEI+GHiusp+vnY
        d6ag==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZI/ScIzb9"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x0OE6jeiX
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 24 Jan 2021 15:06:45 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     ebiggers@kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
        linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        simo@redhat.com
Subject: [PATCH v2 4/7] security: DH - remove dead code for zero padding
Date:   Sun, 24 Jan 2021 15:03:50 +0100
Message-ID: <2129848.iZASKD2KPV@positron.chronox.de>
In-Reply-To: <1772794.tdWV9SEqCh@positron.chronox.de>
References: <1772794.tdWV9SEqCh@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Remove the specific code that adds a zero padding that was intended
to be invoked when the DH operation result was smaller than the
modulus. However, this cannot occur any more these days because the
function mpi_write_to_sgl is used in the code path that calculates the
shared secret in dh_compute_value. This MPI service function guarantees
that leading zeros are introduced as needed to ensure the resulting data
is exactly as long as the modulus. This implies that the specific code
to add zero padding is dead code which can be safely removed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 security/keys/dh.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index 1abfa70ed6e1..56e12dae4534 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -141,7 +141,7 @@ static void kdf_dealloc(struct kdf_sdesc *sdesc)
  * 'dlen' must be a multiple of the digest size.
  */
 static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
-		   u8 *dst, unsigned int dlen, unsigned int zlen)
+		   u8 *dst, unsigned int dlen)
 {
 	struct shash_desc *desc = &sdesc->shash;
 	unsigned int h = crypto_shash_digestsize(desc->tfm);
@@ -158,22 +158,6 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
 		if (err)
 			goto err;
 
-		if (zlen && h) {
-			u8 tmpbuffer[32];
-			size_t chunk = min_t(size_t, zlen, sizeof(tmpbuffer));
-			memset(tmpbuffer, 0, chunk);
-
-			do {
-				err = crypto_shash_update(desc, tmpbuffer,
-							  chunk);
-				if (err)
-					goto err;
-
-				zlen -= chunk;
-				chunk = min_t(size_t, zlen, sizeof(tmpbuffer));
-			} while (zlen);
-		}
-
 		if (src && slen) {
 			err = crypto_shash_update(desc, src, slen);
 			if (err)
@@ -198,7 +182,7 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
 
 static int keyctl_dh_compute_kdf(struct kdf_sdesc *sdesc,
 				 char __user *buffer, size_t buflen,
-				 uint8_t *kbuf, size_t kbuflen, size_t lzero)
+				 uint8_t *kbuf, size_t kbuflen)
 {
 	uint8_t *outbuf = NULL;
 	int ret;
@@ -211,7 +195,7 @@ static int keyctl_dh_compute_kdf(struct kdf_sdesc *sdesc,
 		goto err;
 	}
 
-	ret = kdf_ctr(sdesc, kbuf, kbuflen, outbuf, outbuf_len, lzero);
+	ret = kdf_ctr(sdesc, kbuf, kbuflen, outbuf, outbuf_len);
 	if (ret)
 		goto err;
 
@@ -384,8 +368,7 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 		}
 
 		ret = keyctl_dh_compute_kdf(sdesc, buffer, buflen, outbuf,
-					    req->dst_len + kdfcopy->otherinfolen,
-					    outlen - req->dst_len);
+					    req->dst_len + kdfcopy->otherinfolen);
 	} else if (copy_to_user(buffer, outbuf, req->dst_len) == 0) {
 		ret = req->dst_len;
 	} else {
-- 
2.26.2




