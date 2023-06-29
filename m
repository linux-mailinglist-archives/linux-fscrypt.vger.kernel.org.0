Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9F97423A9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 12:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjF2KEW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Jun 2023 06:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjF2KDW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Jun 2023 06:03:22 -0400
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290BCA2;
        Thu, 29 Jun 2023 03:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; s=LIY0OQ3MUMW6182UNI14; d=nsr.re.kr; t=1688032763; c=relaxed/relaxed; h=content-type:date:from:message-id:mime-version:subject:to; bh=Zafm6bhK5+g2pK+OZH6WFKiywi+VCeOoYHGecdFYKnw=; b=aEKRcS33y5MRO4r7i3L8Qk9RgJ4CNG5NED3OSgsQG7NhpbA8b16V2nb9+1gzJ16punKh6SG8mWIzGpqza8YsZb2WBFSC/3ak9OSutv/7g57MGn/DsuuJTAxYOXNPfH1rYSc0jlaQ7l3xh3MtMytZIAen9PlXWq9b5ndf34A3rowFBo+UqMdceMZBhjn4qnpybwFOTMGegYu8fke65tNFB6z7jFZ8cPNB34ETxsuuzBayOVLhT5xwIn+2x/Pr/50vkPEp0LtvnxZWMK8RO4JcMdr3NigSCTmi9N3JrP5DWzP/4/GLNPVrAFjLMIrG/QlWkwDXTngXq/2azBVQtMGnQw==
Received: from 210.104.33.70 (nsr.re.kr)
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
        by mail.nsr.re.kr with SMTP; Thu, 29 Jun 2023 18:59:08 +0900
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 209;
          Thu, 29 Jun 2023 19:01:14 +0900 (KST)
From:   Dongsoo Lee <letrhee@nsr.re.kr>
To:     'Eric Biggers' <ebiggers@kernel.org>
Cc:     'Herbert Xu' <herbert@gondor.apana.org.au>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jens Axboe' <axboe@kernel.dk>,
        "'Theodore Y. Ts'o'" <tytso@mit.edu>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230626084703.907331-1-letrhee@nsr.re.kr> <20230626084703.907331-5-letrhee@nsr.re.kr> <20230628063830.GA7920@sol.localdomain>
In-Reply-To: <20230628063830.GA7920@sol.localdomain>
Subject: RE: [PATCH v3 4/4] fscrypt: Add LEA-256-XTS, LEA-256-CTS support
Date:   Thu, 29 Jun 2023 19:01:11 +0900
Message-ID: <000901d9aa70$a228c420$e67a4c60$@nsr.re.kr>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQHHxDRlmstc7qqNSJFY4M8BkkyX4gFqzZG4AcdR3rmvq8ZzIA==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jun 27, 2023 at 23:38:30 -0700, Eric Biggers wrote:
>On Mon, Jun 26, 2023 at 05:47:03PM +0900, Dongsoo Lee wrote:
>> when SIMD instructions are available, it performs even faster.
>
>This will only be true once there is actually an applicable implementation
of
>LEA-XTS and LEA-CTS using SIMD instructions included in the kernel.
>
>Perhaps it is your plan to go through and accelerate LEA-XTS and LEA-CTS
for the
>common CPU architectures.  However, it is not included in this patchset
yet, so
>it should not be claimed in the documentation yet.
>
>> Particularly, it outperforms AES when the dedicated crypto
>> +instructions for AES are unavailable, regardless of the presence of SIMD
>> +instructions. However, it is not recommended to use LEA unless there is
>> +a clear reason (such as the absence of dedicated crypto instructions for
>> +AES or a mandatory requirement) to do so. Also, to enable LEA support,
>> +it needs to be enabled in the kernel crypto API.
>
>I think I'd prefer that you omit the mention of the "absence of dedicated
crypto
>instructions" use case for now.  fscrypt already supports another algorithm
that
>fulfills exactly that use case (Adiantum), and that algorithm already has
>optimized implementations for arm32, arm64, and x86_64.  LEA does not have
that
>yet.  So it does not really bring anything new to the table.  I'm also
unsure it
>would be appropriate to recommend a "lightweight" cipher at this point...
>
>That would leave "mandatory requirement" as the rationale, at least for
now,
>similar to SM4.
>
>- Eric

As you might expect, we are working on a SIMD implementation of LEA in a
general-purpose CPU environment. However, since no such implementation has
been submitted yet, we agree that it's right to leave it out for now.

In the next version, we would like to change the description to the
following:

LEA is a South Korean 128-bit block cipher (with 128/192/256-bit keys)
included in the ISO/IEC 29192-2:2019 standard (Information security -
Lightweight cryptography - Part 2: Block ciphers). If dedicated cipher
instructions are available, or other options with performance benefits
are available, using LEA is likely not a suitable choice. Therefore,
it is not recommended to use LEA-256-XTS unless there is a clear reason
to do so, such as if there is a mandate. Also, to enable LEA support,
it needs to be enabled in the kernel crypto API.
