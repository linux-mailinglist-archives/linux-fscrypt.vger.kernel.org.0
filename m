Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B276685C67
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Feb 2023 01:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjBAAsy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Jan 2023 19:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjBAAsx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Jan 2023 19:48:53 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB297125A3;
        Tue, 31 Jan 2023 16:48:52 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 6F5F120E0A00; Tue, 31 Jan 2023 16:48:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6F5F120E0A00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675212532;
        bh=QtJOGoJNRx6Y5psopcsbrkvVOd9n83DwG6TAX2fVAEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qhvwMPCpPd9vbDNzrPjs1oZIe5jI0seyMdSzUuuc5HR6DkZ14Hf6P0cI2f+oh6DGv
         76VMuAXIVoCv65wvxPld5tZex+OTLKcBVka2rNlJJBrhjS44ZIHEQ+lFV1y4yUS9qY
         CduWMrllvFR26wDQtbMgNAHH2QmUm72WhSPXXT2E=
Date:   Tue, 31 Jan 2023 16:48:52 -0800
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
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v9 00/16] Integrity Policy Enforcement LSM (IPE)
Message-ID: <20230201004852.GB30104@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <033335b26f6becdc3dc0325ef926efd94fcc4dda.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <033335b26f6becdc3dc0325ef926efd94fcc4dda.camel@huaweicloud.com>
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

On Tue, Jan 31, 2023 at 03:22:05PM +0100, Roberto Sassu wrote:
> On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > IPE has two known gaps:
> > 
> > 1. IPE cannot verify the integrity of anonymous executable memory, such as
> >   the trampolines created by gcc closures and libffi (<3.4.2), or JIT'd code.
> >   Unfortunately, as this is dynamically generated code, there is no way
> >   for IPE to ensure the integrity of this code to form a trust basis. In all
> >   cases, the return result for these operations will be whatever the admin
> >   configures the DEFAULT action for "EXECUTE".
> 
> I think it would be useful to handle special cases, for example you
> could allow a process that created a file with memfd to use it, at the
> condition that nobody else writes it.
> 
> This would be required during the boot, otherwise services could fail
> to start (depending on the policy).
> 
Thanks for the suggestion. I agree with your opinion and I think supporting
memfd is possible but restricting read/write needs more hooks. We would like
to avoid adding more complexity to this initial posting as necessary. 
We will consider this as a future work and will post follow-on patches
in the future.

-Fan

> > 2. IPE cannot verify the integrity of interpreted languages' programs when
> >   these scripts invoked via ``<interpreter> <file>``. This is because the
> >   way interpreters execute these files, the scripts themselves are not
> >   evaluated as executable code through one of IPE's hooks. Interpreters
> >   can be enlightened to the usage of IPE by trying to mmap a file into
> >   executable memory (+X), after opening the file and responding to the
> >   error code appropriately. This also applies to included files, or high
> >   value files, such as configuration files of critical system components.
> 
> Ok, it is a well known issue. Hopefully, it will be fixed soon.
> 
> Roberto
> 
