Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A28636FBE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Nov 2022 02:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiKXBWk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Nov 2022 20:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiKXBWj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Nov 2022 20:22:39 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF863B6;
        Wed, 23 Nov 2022 17:22:35 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 1D6468113C;
        Wed, 23 Nov 2022 20:22:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1669252953; bh=e5+Kz0offVYjfTdxHxRxQIsU/8g83AfXqzC8JSA/ZHo=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=MeCEPKpV7DeGAKi/iRuB5ff3DWjWDBD/L2CgkXQ03wy/EMGojetlWhytM3dcEKZF9
         OS1GfZscBrk59EzCyqkM/WGeSSh5Yzp3AT7QCdHaTG6PhQBOLeQOhpSRs71dwZNyAB
         PYC8A9IcK89o0NqxmVj17wbvfgECWGB8RwZDZfc3EuJkS0Sq08p4hPsm78lmt44sdG
         +gaxQ+n/yj83Vif/ZS5NkrfMFUM3i64ibkke/Eu89WhM7UDo6rONkak+5+1Te3TD+u
         FX2xHXdGmnz0RNz361PH2PPNQUl7e6Gjaef1nCA7xnitextHljQyPBeTIh/w7OLjKJ
         L1q+UWQ9DTmeg==
Message-ID: <4857f0df-dae0-178e-85e3-307197701d34@dorminy.me>
Date:   Wed, 23 Nov 2022 20:22:30 -0500
MIME-Version: 1.0
Subject: Re: [PATCH v5 00/18] btrfs: add fscrypt integration
Content-Language: en-US
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Paul Crowley <paulcrowley@google.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>, Chris Mason <clm@fb.com>
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
 <CA+_SqcAFMXjW6V2u1NZzGwBe4na4m_FBspgP0Z6Q0oTvT+QJVQ@mail.gmail.com>
 <81e3763c-2c02-2c9f-aece-32aa575abbca@dorminy.me>
 <55686ed2-b182-3478-37aa-237e306be6e1@dorminy.me>
In-Reply-To: <55686ed2-b182-3478-37aa-237e306be6e1@dorminy.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

We had a very productive meeting and have greatly changed the design: we 
now plan to implement authenticated encryption, and have per-extent keys 
instead of per-extent nonces, which will greatly improve the 
cryptographic characteristics over this version. Many thanks for the 
discussion, both in the meeting and on the document.

The document has been updated to hopefully reflect the discussion we 
had; further comments are always appreciated. 
https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing 


I look forward to working on implementing the new design; thanks to all!

Sweet Tea

On 11/21/22 12:26, Sweet Tea Dorminy wrote:
> I appreciate the conversation happening on the doc; thank ya'll for 
> reading and commenting.
> 
> Would it be worth having a meeting on Zoom or the like this week to 
> discuss the way forward for getting encryption for btrfs, be that one of 
> the extent-based encryption variations or AEAD?
> 
> Thanks!
> 
> Sweet Tea
> 
> On 11/16/22 15:19, Sweet Tea Dorminy wrote:
>>
>>
>> On 11/3/22 15:22, Paul Crowley wrote:
>>> Thank you for creating this! I'm told the design document [1] no
>>> longer reflects the current proposal in these patches. If that's so I
>>> think it's worth bringing the design document up to date so we can
>>> review the cryptography. Thanks!
>>>
>>> [1] 
>>> https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk9ALQW3XuII/edit
>>
>> I apologize for the delay; I realized when this thread was bumped just 
>> now that my attempt to share the updated doc didn't seem to make it to 
>> the mailing list.
>>
>> https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing is an update of the design document that hopefully is what you're requesting.
