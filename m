Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7689D358CD6
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhDHSml (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:42:41 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:50911 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231676AbhDHSml (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:42:41 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 2CBE9E77;
        Thu,  8 Apr 2021 14:42:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 08 Apr 2021 14:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=yzcAtZT9Dyb7OqvMyK9nADe5EpH
        /6WzG52UOhCjmVPs=; b=Q8G+uxfNSZ3sn1i83tJbBssdl+oN/3y2Mza8Ry/A2mp
        50BLzpJQyrbieP2GaiHtffC3wx5wj8S8NqbptWtzP3JgTVIuoT95w7LnE2Esu2Lp
        sFnlzchM4jjWXOOkjUnBvEuPca0tr7kShmXdlVAEPod3WLoQhktp+MNhBu51hwNQ
        23Q1SbnJpcIjgB27n++/6czoTXrHYr13BuUBOybYBmB9SmpaSkR5eFM4ihYyQZPe
        gWqdUvM9GZq1Bu3eJFwTHsHPuzqj4XQxzFGewfRb2i1MRFES8bvsW+X2WlfUi2Wm
        tnhtkTtVxhw9mbXFjoYESjdJZ8E9Qq+nkU0hVmYuxwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yzcAtZ
        T9Dyb7OqvMyK9nADe5EpH/6WzG52UOhCjmVPs=; b=byw2QZcQwqaHdQjvuPmLNx
        oQwX8QMRUvTQ4G2xbMp7uZWVMDGUum2ZetdVFpNTlpzUw1AwQDsP+Cj2AuAUvlU9
        k9hoQV+cv1eghjFY25dp5ZZJpa9njUCtGoXp5/tryBkgGvZaaO8+GABmM43+z5YE
        KwrLPMYrDqiHuuliSBfDuqZz7PTyojv/ahEH2lzIuYFIhptZt6/WZi9Mcpy5t219
        covbE2Rash59QQvo0HUYeStIb3kiVufXZh9XBD/OwHeUqni8P07vFAnKi/DCSAto
        5awriyiwawCIzRF2Cjzh3dS4nrtiVWBNONxu8x0TmMo9gBbKvChCpytePIeiysLg
        ==
X-ME-Sender: <xms:k05vYFFeVvvx981N91ZjPF__Z2LZLsawn3Hk-3W8zg_8gmrUnroODA>
    <xme:k05vYIQ2aCNhQyRl1HyFruY6ZS-ONWYRZ2FC47b3DJV-_WL75aWXg3id7Nd3Il_Zy
    Bv_omSKuD2JfY4A-vY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    fhgfevjeetgedtleehtdeivdekvddtgfevleeltdejffevkeegfeelueeljeduveenucff
    ohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppedvtdejrdehfedrvdehfedrjeenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhs
    segsuhhrrdhioh
X-ME-Proxy: <xmx:lE5vYJcPe2UJ2W8zvTmCbZqN5WqMOn3Qw7wWb5Y7wCMwyZFoWqD8iw>
    <xmx:lE5vYPqnXl9bVZtM6NBpTiGYyqiNoynIlVu-2bK-moRCMz2JmAD0Vg>
    <xmx:lE5vYC-RnTCFO52JQc5MhdBnX5hSjflKYoCM9AEtglCzQfWPwtfM1Q>
    <xmx:lE5vYE5_SZnFgG-b18VF21PI7nChik8Dtfvpc9XfM48d8ZnAC34K_A>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id C820F240054;
        Thu,  8 Apr 2021 14:42:27 -0400 (EDT)
Date:   Thu, 8 Apr 2021 11:42:26 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 0/3] tests for btrfs fsverity
Message-ID: <YG9Oktk8IT9CDFz4@zen>
References: <cover.1617906318.git.boris@bur.io>
 <YG9NLpg/EV3zfvsa@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG9NLpg/EV3zfvsa@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 08, 2021 at 11:36:30AM -0700, Eric Biggers wrote:
> On Thu, Apr 08, 2021 at 11:30:10AM -0700, Boris Burkov wrote:
> > This patchset provides tests for fsverity support in btrfs.
> > 
> > It includes modifications for generic tests to pass with btrfs as well
> > as new btrfs specific tests.
> 
> Which commit does this apply to?  It doesn't apply to the latest xfstests master
> branch.
> 

Oh, I'm quite sorry about that.
This is written on top of the btrfs group's xfstests staging branch.
for reference, that's:
901c7750a6add
from https://github.com/btrfs/fstests/tree/staging

I'll rebase on the xfstests master branch and re-send it.

> - Eric
