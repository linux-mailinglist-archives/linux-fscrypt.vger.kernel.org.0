Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63FA7766E1
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 20:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjHISCz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Aug 2023 14:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbjHISCp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Aug 2023 14:02:45 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FE2E19A1;
        Wed,  9 Aug 2023 11:02:43 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id F276320FC4C4; Wed,  9 Aug 2023 11:02:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F276320FC4C4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1691604163;
        bh=2BAEPHZjC1csVSUp5YiA21kHWYMQI2muR+jIz+ByF+4=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=V0JoJpg23L/peNkCEvzn4viDNmOHVq322EXzMIkHlzswJAG/7x2U+HK9aVOM+hySz
         mbJuWfMNHkSfC5A/dOjdMfskmaecJosfCzIgyyFlwjv23+hsdZtd9zVTW2hG2gpZGJ
         y6qnuS91reyXsJjl52Mc922yNssoBNVK4a9tvzQs=
Date:   Wed, 9 Aug 2023 11:02:42 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>,
        Mike Snitzer <snitzer@kernel.org>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v10 11/17] dm-verity: consume root hash digest and
 signature data via LSM hook
Message-ID: <20230809180242.GA23396@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
 <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
 <ZKgm+ffQbdDTxrg9@redhat.com>
 <20230712034319.GA17642@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQFxqcfgR0acgdiXKP9LT1KLgGjZd-QHs6O1dEex31HEQ@mail.gmail.com>
 <20230808224503.GA20095@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20230808234023.GC120054@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808234023.GC120054@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 09, 2023 at 12:40:23AM +0100, Alasdair G Kergon wrote:
> On Tue, Aug 08, 2023 at 03:45:03PM -0700, Fan Wu wrote:
> > On Tue, Jul 25, 2023 at 04:43:48PM -0400, Paul Moore wrote:
> > > Where would the finalize() hook be called?
> > 
> > It is in the __bind function in drivers/md/dm.c, calling just before 
> > rcu_assign_pointer(md->map, (void *)t) which activates the inactive table.
>  
> That would be after the existing commit point, meaning the table swap
> cannot be cancelled there, so is the finalize() you are proposing void()
> i.e. designed so it always succeeds?
> 
> Alasdair

Thanks for the input.

Actually, no, the hook can be failed. I noticed the existing call before rcu_assign_pointer(md->map, (void *)t);
(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/md/dm.c#n2255)
can also be failed so I was following the same pattern.

Could you explain a bit more about the "commit point"? It sounds like it might be better to move
the hook call just before the commit point instead.

-Fan
