Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687B868E4F7
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Feb 2023 01:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjBHAbG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Feb 2023 19:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBHAbF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Feb 2023 19:31:05 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CFC93AAC;
        Tue,  7 Feb 2023 16:31:04 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 91E3120C7E38; Tue,  7 Feb 2023 16:31:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 91E3120C7E38
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675816263;
        bh=LeJteH6AJ9Cbyv23AKIZT9Zr5jPTl5CR5NBjrB7jEH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bs+VMgppVphlNRwXazqjLvcderqyiIoxWf+J92+m0ALQDuvgh/o/nhk1BNWcBQsPh
         gz0C3u2HuwTEnY5P1iqMjO1CzkD/+HiRK+CfRh+GX6szjyKALHkQS/5Vqjg1EHw7/2
         kMQ7Bn9LNIzaQRwZ/K5EZ4sZYQKeFDqpGmC9IVrc=
Date:   Tue, 7 Feb 2023 16:31:03 -0800
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
Message-ID: <20230208003103.GC5107@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <033335b26f6becdc3dc0325ef926efd94fcc4dda.camel@huaweicloud.com>
 <20230201004852.GB30104@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <7dc9963c563d0b55bb35109be012e355eef13882.camel@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dc9963c563d0b55bb35109be012e355eef13882.camel@huaweicloud.com>
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

On Thu, Feb 02, 2023 at 11:48:18AM +0100, Roberto Sassu wrote:
> On Tue, 2023-01-31 at 16:48 -0800, Fan Wu wrote:
> > On Tue, Jan 31, 2023 at 03:22:05PM +0100, Roberto Sassu wrote:
> > > On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > > > IPE has two known gaps:
> > > > 
> > > > 1. IPE cannot verify the integrity of anonymous executable memory, such as
> > > >   the trampolines created by gcc closures and libffi (<3.4.2), or JIT'd code.
> > > >   Unfortunately, as this is dynamically generated code, there is no way
> > > >   for IPE to ensure the integrity of this code to form a trust basis. In all
> > > >   cases, the return result for these operations will be whatever the admin
> > > >   configures the DEFAULT action for "EXECUTE".
> > > 
> > > I think it would be useful to handle special cases, for example you
> > > could allow a process that created a file with memfd to use it, at the
> > > condition that nobody else writes it.
> > > 
> > > This would be required during the boot, otherwise services could fail
> > > to start (depending on the policy).
> > > 
> > Thanks for the suggestion. I agree with your opinion and I think supporting
> > memfd is possible but restricting read/write needs more hooks. We would like
> > to avoid adding more complexity to this initial posting as necessary. 
> > We will consider this as a future work and will post follow-on patches
> > in the future.
> 
> Ok, maybe it is necessary to specify better the scope of IPE, why the
> current implementation can be considered as complete.
> 
> If we say, IPE can only allow/deny operations on system components with
> immutable security properties, clearly memfd as a component cannot
> fullfill this goal due to the non-immutability. This would apply to any
> component allowing modifications.
> 
> How to address this? What is the immutable property then?
> 
> In the case of memfd, intuitively, a useful property for integrity
> could be for example that the content can be accessed/modified by only
> one process. No other (possibly malicious) processes can tamper with
> that file.
> 
> So, it is true, to make this property immutable more hooks are needed.
> But should it be something that IPE does? Or it should be done by an
> external component (another LSM) that does the enforcement and reports
> to IPE that the property is true? Theoretically (with a proper policy),
> existing LSMs could be used for that purpose too.
> 
> I would say more the second, it should not be IPE job, so that IPE can
> exclusively focus on evaluating properties, not making sure that the
> properties are immutable.
> 
> Roberto
> 
I think the issue here is not about the scope of IPE but the use cases
of IPE. 

We use IPE on fixed-function devices, which are completely locked down.
In our system, IPE denies all anonymous memory execution so memfd will
not work on our system.

Therefore, to make memfd useable with IPE we must add more properties.

-Fan
