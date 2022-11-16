Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37EEA62CA90
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Nov 2022 21:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiKPUTK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Nov 2022 15:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiKPUTJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Nov 2022 15:19:09 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A969858BC1;
        Wed, 16 Nov 2022 12:19:03 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7D3078136E;
        Wed, 16 Nov 2022 15:19:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1668629943; bh=0nUIsq7G/LC75qgUSwKZKm2GlQ2TH1ewFLkMMAll3jg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=a7CdxwJmpbni2z7VAMmHvRrNVkN7LqKxarUHsZu6bvVd8rtdOxzZLfCrsPnUgqhAC
         QfBlWlyMHe5sBwae0xkgXBNFIsX4SSVaMK6yafoUf0WgX6OFwBQucO0BRiJ8CeY5eU
         5E9yw0vSv0yBNQnvVWHTTkl/JNknBwwwSEMEHiVD03JcKys6UPZoDsyIS7MSkjZU7j
         RfWDZp40Idwa8EceFZDtr2cec0YO3rxi1vJtTvfnXHgtA7VNH+cHku+2uDOfRSYsQo
         3O2vDdEzhoBNNRlBCDVsbRzIadXP4grYw0x+Xn7gxKTLdyBfs1PJJAXRZanh20NQj0
         JHT4A9pf5RydQ==
Message-ID: <81e3763c-2c02-2c9f-aece-32aa575abbca@dorminy.me>
Date:   Wed, 16 Nov 2022 15:19:00 -0500
MIME-Version: 1.0
Subject: Re: [PATCH v5 00/18] btrfs: add fscrypt integration
Content-Language: en-US
To:     Paul Crowley <paulcrowley@google.com>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
 <CA+_SqcAFMXjW6V2u1NZzGwBe4na4m_FBspgP0Z6Q0oTvT+QJVQ@mail.gmail.com>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <CA+_SqcAFMXjW6V2u1NZzGwBe4na4m_FBspgP0Z6Q0oTvT+QJVQ@mail.gmail.com>
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



On 11/3/22 15:22, Paul Crowley wrote:
> Thank you for creating this! I'm told the design document [1] no
> longer reflects the current proposal in these patches. If that's so I
> think it's worth bringing the design document up to date so we can
> review the cryptography. Thanks!
> 
> [1] https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk9ALQW3XuII/edit

I apologize for the delay; I realized when this thread was bumped just 
now that my attempt to share the updated doc didn't seem to make it to 
the mailing list.

https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing 
is an update of the design document that hopefully is what you're 
requesting.
