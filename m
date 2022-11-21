Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687A0632AE9
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Nov 2022 18:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiKUR1A (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Nov 2022 12:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiKUR04 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Nov 2022 12:26:56 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E996CB9CC;
        Mon, 21 Nov 2022 09:26:55 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 9D827825BD;
        Mon, 21 Nov 2022 12:26:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1669051614; bh=hjT9+VScwwtAvmermh5LJ21WaXYQ1R24NV6Ef++5l7w=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=sMPiEYRbUPg2zG6zaCENViYBcgQilN/jsxHDIhNDE/5zrIIOVUNzELZCCRVNbT/c4
         QhOMtoYNMqQ+zz6GYI33ovaWCfin+ktxPdYR3h7vlVJNsmuDNpLD9aG+PmFxmQqB50
         0eK/839ZCJFUKQEN1gkHxktmPhRtmQxHLzjBrS7mL2ngY2R0txkawkRAotnSzHxq8D
         zIkKAdccYxz9ceH9d3xx8HXWFSxZ0CvqHz3+MAGqdYPpSWBkxkgTX4GQyTjRuJnN/j
         PFSqKDZG392f9JyuuDpwXZ43hkNDsyXw3mZAyiMLIKkmVxfCBEOlIM7zTUw7AArorN
         05rkhat7FO55g==
Message-ID: <55686ed2-b182-3478-37aa-237e306be6e1@dorminy.me>
Date:   Mon, 21 Nov 2022 12:26:51 -0500
MIME-Version: 1.0
Subject: Re: [PATCH v5 00/18] btrfs: add fscrypt integration
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
Content-Language: en-US
In-Reply-To: <81e3763c-2c02-2c9f-aece-32aa575abbca@dorminy.me>
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

I appreciate the conversation happening on the doc; thank ya'll for 
reading and commenting.

Would it be worth having a meeting on Zoom or the like this week to 
discuss the way forward for getting encryption for btrfs, be that one of 
the extent-based encryption variations or AEAD?

Thanks!

Sweet Tea

On 11/16/22 15:19, Sweet Tea Dorminy wrote:
> 
> 
> On 11/3/22 15:22, Paul Crowley wrote:
>> Thank you for creating this! I'm told the design document [1] no
>> longer reflects the current proposal in these patches. If that's so I
>> think it's worth bringing the design document up to date so we can
>> review the cryptography. Thanks!
>>
>> [1] 
>> https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk9ALQW3XuII/edit
> 
> I apologize for the delay; I realized when this thread was bumped just 
> now that my attempt to share the updated doc didn't seem to make it to 
> the mailing list.
> 
> https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing is an update of the design document that hopefully is what you're requesting.
