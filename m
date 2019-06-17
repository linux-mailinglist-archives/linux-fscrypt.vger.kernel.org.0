Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558914899C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jun 2019 19:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfFQRF4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jun 2019 13:05:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43639 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQRFz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jun 2019 13:05:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so10767758wru.10;
        Mon, 17 Jun 2019 10:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lvgi3+MQpM39FRojWazLhVvXezLQFMNFRlMRkueq/IA=;
        b=TxjoaKSD5m7bbK0Ih6BMmri+IaS5q+Ny+TFg8Gks5rIBqgGe2z3kV9mvy0d6exbcNP
         aJT2NQySaV8BAnqHAuXv4h4Nqx1H7TxFvtMqRNtOjc2RNZWInHZgqxvGjiKYOAhOvI6j
         Gv9uDdha/tJomPbIALK6ispRrcheUinwcrpynnjDxnFTZudsffVMK4n5pCPOXGK1adtu
         JDB3c29gfzY6S1K7hOj9ROoPwMTAaRKPer6hNujCe7jMnQHAPC4Vews0ca4/Plb396Iw
         QvkSBGqPnvQ/47zRhczZlPValAMW7y73+iZDdWivWjSSyLm+8G9pWyjU7GFfc1fSMXE8
         7wTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lvgi3+MQpM39FRojWazLhVvXezLQFMNFRlMRkueq/IA=;
        b=jdNUIW/qr02QSYVgIfm4X0/rlCwAWg1fJEAFpo8f3xnm+dAiQOG1ZFGLAkWYejcN1v
         Xarj+5MmQvcikM8ttagsMNKtsVQpqlapVSHdt76Kma6lNHv9LJC7FyRzX/edGNc23q7r
         2qJ1wrWDYWaFpLi/6+ThKxr1bFPeWwONVgNwsahCdtLxqfuP9zx1QAKwnbjZJQCJbL6W
         sSvKbDSaxiUQYFB7DdQbLoDzZA5cG0ShxGFaGTL8RX6diJ8QkmLAAga44xcjSna/uUyU
         LfDiMf/Aj2xBCaKTIJhKh/ZJMgYjq3drpehCctFUWBYdVwiph4QwhKgFSYSmZg1HDO1W
         APOQ==
X-Gm-Message-State: APjAAAXEqstzq4rcOHLylC8P06vqC5hBo59D74obSRtTgqbg0eiPS+k4
        7E/zQv9H91d555Ft+4NXKYfPr7HG6Y9wRA==
X-Google-Smtp-Source: APXvYqzi0lLsm2064v1e5vDyLtdJ8bwCyUjazq2dKJytAV5jDeZySSDFNCf3pFZETLZqzrpwnpLjsw==
X-Received: by 2002:adf:f946:: with SMTP id q6mr25621385wrr.109.1560791153693;
        Mon, 17 Jun 2019 10:05:53 -0700 (PDT)
Received: from [192.168.2.28] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id o14sm10435129wrp.77.2019.06.17.10.05.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 10:05:52 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Milan Broz <gmazyland@gmail.com>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain>
 <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
 <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
 <8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com>
 <CAKv+Gu9sb0t6EC=MwVfqTw5TKtatK-c8k3ryNUhV8O0876NV7g@mail.gmail.com>
 <CAKv+Gu-LFShLW-Tt7hwBpni1vQRvv7k+L_bpP-wU86x88v+eRg@mail.gmail.com>
 <90214c3d-55ef-cc3a-3a04-f200d6f96cfd@gmail.com>
 <CAKv+Gu82BLPWrX1UzUBLf7UB+qJT6ZPtkvJ2Sa9t28OpXArhnw@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <af1b7ea1-bc98-06ff-e46c-945e6bae20d8@gmail.com>
Date:   Mon, 17 Jun 2019 19:05:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu82BLPWrX1UzUBLf7UB+qJT6ZPtkvJ2Sa9t28OpXArhnw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 17/06/2019 16:39, Ard Biesheuvel wrote:
>>
>> In other words, if you add some additional limit, we are breaking backward compatibility.
>> (Despite the configuration is "wrong" from the security point of view.)
>>
> 
> Yes, but breaking backward compatibility only happens if you break
> something that is actually being *used*. So sure,
> xts(aes)-essiv:sha256 makes no sense but people use it anyway. But is
> that also true for, say, gcm(aes)-essiv:sha256 ?

These should not be used.  The only way when ESSIV can combine with AEAD mode
is when you combine length-preserving mode with additional integrity tag, for example

  # cryptsetup luksFormat -c aes-cbc-essiv:sha256 --integrity hmac-sha256 /dev/sdb

it will produce this dm-crypt cipher spec:
  capi:authenc(hmac(sha256),cbc(aes))-essiv:sha256

the authenc(hmac(sha256),cbc(aes)) is direct crypto API cipher composition, the essiv:sha256
IV is processed inside dm-crypt as IV.

So if authenc() composition is problem, then yes, I am afraid these can be used in reality.

But for things like gcm(aes)-essiv:sha256 (IOW real AEAD mode with ESSIV) - these are
not supported by cryptsetup (we support only random IV in this case), so these should
not be used anywhere.

Milan
