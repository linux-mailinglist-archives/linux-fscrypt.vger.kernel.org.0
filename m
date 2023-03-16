Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13826BDC11
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Mar 2023 23:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjCPWxn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Mar 2023 18:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCPWxm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Mar 2023 18:53:42 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BC3B2F7BB;
        Thu, 16 Mar 2023 15:53:41 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id EC6622057035; Thu, 16 Mar 2023 15:53:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EC6622057035
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1679007220;
        bh=ozAKii3/G+nF0B4iMSAidkpr8EKBtFwptQ71Sgukeww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KkZPlvrZkwVJk9N6tCVcfEWVijYklxICoHBlfmIBUdyC9L+DFQd4o9FIlLtaz5zo9
         LlqgvLme5WmK8AGXZvR43afaNUceUwk8wqOJUB8SBwuHtIGBuXChLJM+Ctaq1+q6w0
         SjFFKl2n5uJm/6kczK6TR5zqAcTMDJ2OG5M9TlUA=
Date:   Thu, 16 Mar 2023 15:53:40 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Steve Grubb <sgrubb@redhat.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
        linux-audit@redhat.com, dm-devel@redhat.com,
        linux-doc@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        roberto.sassu@huawei.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org
Subject: Re: [RFC PATCH v9 07/16] uapi|audit|ipe: add ipe auditing support
Message-ID: <20230316225340.GB22567@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-8-git-send-email-wufan@linux.microsoft.com>
 <3723852.kQq0lBPeGt@x2>
 <CAHC9VhRqMrTuvVtwzJoK2U=6O1QuaQ8ceA6+qm=6ib0TOUEeSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRqMrTuvVtwzJoK2U=6O1QuaQ8ceA6+qm=6ib0TOUEeSw@mail.gmail.com>
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

On Thu, Mar 02, 2023 at 02:05:33PM -0500, Paul Moore wrote:
> On Tue, Jan 31, 2023 at 12:11???PM Steve Grubb <sgrubb@redhat.com> wrote:
> >
> > Hello,
> >
> > On Monday, January 30, 2023 5:57:22 PM EST Fan Wu wrote:
> > > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > >
> > > Users of IPE require a way to identify when and why an operation fails,
> > > allowing them to both respond to violations of policy and be notified
> > > of potentially malicious actions on their systens with respect to IPE
> > > itself.
> > >
> > > The new 1420 audit, AUDIT_IPE_ACCESS indicates the result of a policy
> > > evaulation of a resource. The other two events, AUDIT_MAC_POLICY_LOAD,
> > > and AUDIT_MAC_CONFIG_CHANGE represent a new policy was loaded into the
> > > kernel and the currently active policy changed, respectively.
> >
> > Typically when you reuse an existing record type, it is expected to maintain
> > the same fields in the same order. Also, it is expect that fields that are
> > common across diferent records have the same meaning. To aid in this, we have
> > a field dictionary here:
> >
> > https://github.com/linux-audit/audit-documentation/blob/main/specs/fields/
> > field-dictionary.csv
> >
> > For example, dev is expected to be 2 hex numbers separated by a colon which
> > are the device major and minor numbers. But down a couple lines from here, we
> > find dev="tmpfs". But isn't that a filesystem type?
> 
> What Steve said.
> 
> I'll also add an administrative note, we just moved upstream Linux
> audit development to a new mailing list, audit@vger.kernel.org, please
> use that in future patch submissions.  As a positive, it's a fully
> open list so you won't run into moderation delays/notifications/etc.
> 
Thanks for the info, I will update the address.

> > > This patch also adds support for success auditing, allowing users to
> > > identify how a resource passed policy. It is recommended to use this
> > > option with caution, as it is quite noisy.
> > >
> > > This patch adds the following audit records:
> > >
> > >   audit: AUDIT1420 path="/tmp/tmpwxmam366/deny/bin/hello" dev="tmpfs"
> > >     ino=72 rule="DEFAULT op=EXECUTE action=DENY"
> >
> > Do we really need to log the whole rule?
> 
> Fan, would it be reasonable to list the properties which caused the
> access denial?  That seems like it might be more helpful than the
> specific rule, or am I missing something?
> 
Audit the whole rule can let the user find the reason of a policy decision.
We need the whole rule because an allow/block is not caused by a specific
property, but the combination of all property conditions in a rule.

We could also add a verbose switch such that we only audit
the whole rule when a user turned the verbose switch on. 

-Fan

> paul-moore.com
