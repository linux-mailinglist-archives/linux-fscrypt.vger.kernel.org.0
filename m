Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D83692B04
	for <lists+linux-fscrypt@lfdr.de>; Sat, 11 Feb 2023 00:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBJXV5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Feb 2023 18:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjBJXVz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Feb 2023 18:21:55 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8860193D0;
        Fri, 10 Feb 2023 15:21:54 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 0D21520C8B19; Fri, 10 Feb 2023 15:21:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0D21520C8B19
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1676071314;
        bh=i2lp2ziiFIPNiUwou6ICbYjzt9rpgm+8uoeH+6Tjq14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g710bbkpK51xjvJHJGmow+Fo5edKRRAgTo+QwsHzaank4bxcVSAeeGsqdn1oWpbTo
         7DVryIkmJ5VTN9TLjgGnxqj0i1Uq+gUjsnTDRaf7H8xwci0S7dOJwYkfBIwdMKw7H4
         KofNpLaIUBMktQ5IplKE8C7Gi/LqrPF8KHBKGhCA=
Date:   Fri, 10 Feb 2023 15:21:54 -0800
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 03/16] ipe: add evaluation loop and introduce
 'boot_verified' as a trust provider
Message-ID: <20230210232154.GA17962@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
 <061df661004a06ef1e8790d48157c7ba4ecfc009.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <061df661004a06ef1e8790d48157c7ba4ecfc009.camel@huaweicloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jan 31, 2023 at 04:49:44PM +0100, Roberto Sassu wrote:
> On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > 
> > IPE must have a centralized function to evaluate incoming callers
> > against IPE's policy. This iteration of the policy against the rules
> > for that specific caller is known as the evaluation loop.
> 
> Not sure if you check the properties at every access.
> 
> >From my previous comments (also for previous versions of the patches)
> you could evaluate the property once, by calling the respective
> functions in the other subsystems.
> 
> Then, you reserve space in the security blob for inodes and superblocks
> to cache the decision. The format could be a policy sequence number, to
> ensure that the cache is valid only for the current policy, and a bit
> for every hook you enforce.

Thanks for raising this idea. I agree that if the property evaluation
leads to a performance issue, it will be better to cache the evaluation
result. But for this version, all the property evaluations are simple,
so it is just as fast as accessing a cache. Also, for the initial
version we prefer to keep the patch as minimal as possible. 

If the policy evolved to be super complex and the evaluation becomes
a bottleneck, cache support will absolutely be the right way we will go.
-Fan

> 
> Also, currently you rely on the fact that the properties you defined
> are immutable and the immutability is guaranteed by the other
> subsystems, so no write can occur.
> 
> But if you remove this limitation, the immutability is not guaranteed
> anymore by the other subsystems (for example if a file is in an ext4
> filesystem), the LSM needs to take extra care to ensure that the
> properties are still verified. This would be required for example if
> IPE is used in conjuction with DIGLIM.
> 
> In my opinion, IPE value would increase if the generic enforcement
> mechanism is property-agnostic.
> 
> Roberto
> 
