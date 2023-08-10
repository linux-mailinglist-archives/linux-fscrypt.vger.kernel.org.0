Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32549777A34
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Aug 2023 16:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbjHJOMB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 10:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbjHJOL6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 10:11:58 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210681B4;
        Thu, 10 Aug 2023 07:11:58 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 188FD80479;
        Thu, 10 Aug 2023 10:11:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691676717; bh=2AFQbLYogCduftlXKy9/CjMj6fE6sTSxC4xe7QZyqqA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=we37bcnoVz60t2e77Ol3ZqkJoqNBwut5RDvQ0LyIfIl//6tf4/96sGT2sz8eJ3j3f
         JsRHxqF6qSL6w1Tvhw/tSrbXjzQGJgc6E+gDZLwOar4DR8g8io0tLeW2q02iw/6uJ2
         UoHcbiuuB9CYEAehZeE0Kn7MqpHXb5uL6w9vv/xBcFLfWIemc+ylD72z7V4BZ/3gyp
         D1CzVrlg6dXs4gpNuECwnq2HftOoBcKCxzeddTzsy7FMLPcFVFclsH048QZkK80VzO
         thl7zFvwwOFBgV//TzGAAZ/mkuEuhpjV4oNSFBHJH3a4461Wv3BWpIyDBPrhx10sP8
         SlXl9BhmIvWuQ==
Message-ID: <408f6654-4fc7-7ae5-616d-6b5ecc24eb2a@dorminy.me>
Date:   Thu, 10 Aug 2023 10:11:56 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v3 00/16] fscrypt: add extent encryption
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
 <20230810045520.GA923@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <20230810045520.GA923@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 8/10/23 00:55, Eric Biggers wrote:
> On Tue, Aug 08, 2023 at 01:08:17PM -0400, Sweet Tea Dorminy wrote:
>> This applies atop [3], which itself is based on kdave/misc-next. It
>> passes encryption fstests with suitable changes to btrfs-progs.
> 
> Where can I find kdave/misc-next?  The only mention of "kdave" in MAINTAINERS is
> the following under BTRFS FILE SYSTEM:
> 
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
> 
> But that repo doesn't contain a misc-next branch.
> 
> - Eric

I should've mentioned that more explicitly since the btrfs dev tree 
isn't listed in MAINTAINERS. 
https://github.com/kdave/btrfs-devel/tree/misc-next

Apologies
