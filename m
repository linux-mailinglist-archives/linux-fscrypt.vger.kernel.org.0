Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B542274363E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 09:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjF3Hxm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 30 Jun 2023 03:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjF3Hxl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 30 Jun 2023 03:53:41 -0400
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BBA1B5;
        Fri, 30 Jun 2023 00:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; s=LIY0OQ3MUMW6182UNI14; d=nsr.re.kr; t=1688111482; c=relaxed/relaxed; h=content-type:date:from:message-id:mime-version:subject:to; bh=Olcp/merrmy+oOHLlTFT/5Sfiagah7Ht2pr+7Tldn3Q=; b=MO9J3prFxRDDPMxKhf2rU8PfEqSGPy9xSABvHSXEeLvfD9vrFhKQJ0cHKAR81TE2nq5kmuBrPMVAflMc9X9yC2ACtJCY8WKXm48MISKrQDxP5oeyfq9k9j8n8lyoeKI7RWCky7CPJ41jJshLXa4a3sb9C16DYNpMNfg2DMhaUdRITBXOPtyViZXh8EuUj8FVqmrgDVU0YsNROJp6o9nMSB+XXVnTbDDmrIs3aBm8TxM6xpd2j90dXWNU+J/+npvlcf7y/2EO/HAJid6e1i1yvbLEhDi53bklwfun2GTmYlee9kr1ssZGrG6nR3gCv9FrIiVYooSVWI70hQQp4G2cEw==
Received: from 210.104.33.70 (nsr.re.kr)
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
        by mail.nsr.re.kr with SMTP; Fri, 30 Jun 2023 16:51:07 +0900
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 289;
          Fri, 30 Jun 2023 16:53:15 +0900 (KST)
From:   Dongsoo Lee <letrhee@nsr.re.kr>
To:     'Eric Biggers' <ebiggers@kernel.org>
Cc:     'Herbert Xu' <herbert@gondor.apana.org.au>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jens Axboe' <axboe@kernel.dk>,
        "'Theodore Y. Ts'o'" <tytso@mit.edu>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230626084703.907331-1-letrhee@nsr.re.kr> <20230626084703.907331-5-letrhee@nsr.re.kr> <20230628063830.GA7920@sol.localdomain> <000901d9aa70$a228c420$e67a4c60$@nsr.re.kr> <20230630025914.GB1088@sol.localdomain> <20230630065953.GA36542@sol.localdomain>
In-Reply-To: <20230630065953.GA36542@sol.localdomain>
Subject: RE: [PATCH v3 4/4] fscrypt: Add LEA-256-XTS, LEA-256-CTS support
Date:   Fri, 30 Jun 2023 16:53:16 +0900
Message-ID: <003901d9ab27$edc44f00$c94ced00$@nsr.re.kr>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHHxDRlmstc7qqNSJFY4M8BkkyX4gFqzZG4AcdR3rkCVVeuvQFbPgFSAXy6NAOvg8kA8A==
Content-Language: ko
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 29, 2023 at 23:59:53 -0700, Eric Biggers wrote:
> I've sent out
> https://lore.kernel.org/linux-fscrypt/20230630064811.22569-1-ebiggers@kernel.org/T/#u.
> One of the things it does is add a nice list for the "national pride ciphers".
> So we can just add ciphers like SM4 and LEA, and any that people might insist on
> adding in the future like Camellia, Kuznyechik, SEED, ARIA, etc., to that list,
> and not have to waste time with each one individually...
> 
> - Eric

That seems reasonable enough to us.

Thank you for your consideration.

