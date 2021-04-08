Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C7B358CE9
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhDHStv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:49:51 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:34123 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231676AbhDHStv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:49:51 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id A8245D3E;
        Thu,  8 Apr 2021 14:49:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 08 Apr 2021 14:49:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Ui0NncOXZ1HAaeNTiKM+baPTBXy
        ZLypqga1b195ukJo=; b=XuPBZPQ7pHeqRsNo7gXv7Gw7qT35SEspqUGDUIetQYS
        R8J62uC6/PCXKxkOO+RUplIGisoH8LzmcM/pPCqgKo3BtwlfIVs6G+sahl7zBaIt
        90eHuid2ncp/7WImLVXsLji8yuK446Hs854I876gKpBJ0/dIHjzgfo8N/xRX79R1
        wxca7c8RpjBSAAJqU1FfPBFSnMnR3oBI9byO3w0+7fzUK8lCLeq0P033VOkTJ3wt
        L12zZEy7AftFb5Add6qFK1KTYZPZb6OmFT7WSZZQb12kX8wP3YHQk8wBltCi8NEX
        C4bkV6UrdwdXQ2lB0p9/gBnP1J++aQsqX0/IjxfFIqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ui0Nnc
        OXZ1HAaeNTiKM+baPTBXyZLypqga1b195ukJo=; b=uj+q21qMLXKMS39TsYzwej
        SPxHBLsI6Et17H4ijUgj6w6Nxw1wsMLqiWbNCVgbcvTlY1EnrEv2s+w1RA/tIQne
        6aN8p3OFZfrl7iuYNGq5ZM8LILlu1srproGizOsP30t0HVP6+JEsnfdN4g/75t1E
        6tR2n64jVK/fd0I6HlFy9PfIEkTuBHACPCGe+jG1/zUPwPDjwUObPxN4t1yfr8GK
        Jrs72GNHyjnNLHTlCzhn1A8vgF6QvIaekg2ASnXxlFsOmkeo6SxOa10+tLbrI8ei
        lOSS7fDoODe91LSoup5IxmACNG9o8WKD0EKEvryp7ti5HDKbDFJUwS+2M2ex1Rzg
        ==
X-ME-Sender: <xms:QlBvYGwjpdW8EyIw44N2opt2JsW5Dnv509iYs-2g59ZgeU8GJo_lyA>
    <xme:QlBvYCQ5qexah5TfgSOdoSl1i-4topxAQnGhs8T7p8TXf7V9ZrcYdhS1YlmFTdhfU
    DbgTYMLk4sTBcXD1Tw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    ehudevleekieetleevieeuhfduhedtiefgheekfeefgeelvdeuveeggfduueevfeenucfk
    phepvddtjedrheefrddvheefrdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:QlBvYIUE9KnKJytnfAEXB5MZMVMvItV4KSIFI9a-yRJdI9xXv2pj5g>
    <xmx:QlBvYMjWdF7nTwZt4BCsHqDOn7YKhHpITW-Ave7m6IkVZiMHwEAamw>
    <xmx:QlBvYIDnWt2KdqR66N29NVkbp2R9I7s2Bqnfx0KSIJTykTKlhq_FZQ>
    <xmx:QlBvYLNky7BMUxcbqSdEHUwDS3tJS_AFqRM27BMJzV14OPthewg8DA>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02EC41080057;
        Thu,  8 Apr 2021 14:49:37 -0400 (EDT)
Date:   Thu, 8 Apr 2021 11:49:37 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 2/3] generic/574: corrupt btrfs merkle tree data
Message-ID: <YG9QQUHzoA045Ngt@zen>
References: <cover.1617906318.git.boris@bur.io>
 <ca320cd0c8427458828cc36d5d5168bbe6b6bab2.1617906318.git.boris@bur.io>
 <YG9OZseq1nGv/wMk@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG9OZseq1nGv/wMk@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 08, 2021 at 11:41:42AM -0700, Eric Biggers wrote:
> On Thu, Apr 08, 2021 at 11:30:12AM -0700, Boris Burkov wrote:
> > 
> > Note that there is a bit of a kludge here: since btrfs_corrupt_block
> > doesn't handle streaming corruption bytes from stdin (I could change
> > that, but it feels like overkill for this purpose), I just read the
> > first corruption byte and duplicate it for the desired length. That is
> > how the test is using the interface in practice, anyway.
> 
> If that's the problem, couldn't you just write the data to a temporary file?

Sorry, I was a bit too vague. It doesn't have a file or stdin interface,
as far as I know.

btrfs-corrupt-block has your typical "kitchen sink of flags" interface and
doesn't currently read input from streams/files. I extended that
interface in the simplest way to support arbitrary corruption, which
didn't fit with the stream based corruption this test does.

my options seem to be:
shoehorn the "byte, length" interface into this test or
shoehorn the "stream corruption input in" interface into
btrfs-corrupt-block.

I have no problem with either, the former was just less work because I
already wrote it that way. If the junk I did here is a deal-breaker, I
don't mind modifying btrfs-corrupt-block.

> 
> - Eric

Thanks for the quick review,
Boris
