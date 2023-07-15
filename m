Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A677546B2
	for <lists+linux-fscrypt@lfdr.de>; Sat, 15 Jul 2023 06:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjGOEAb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 15 Jul 2023 00:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjGOEAa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 15 Jul 2023 00:00:30 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 891473588;
        Fri, 14 Jul 2023 21:00:29 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 1139721C4693; Fri, 14 Jul 2023 21:00:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1139721C4693
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1689393629;
        bh=T+rS0NBXQ8rmZa6Pv6GYhkR4sFygUmWyBqsbSsfgTyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cDoM/dayOIqXlO5WYELh4VdXzsOuz+zQzAmUzPjeRkz74duW+/HbrgjuR4td7uHih
         PVSGFalEqGe64dK1ZYcaRiC6fsORYlkGjN4De35/Ao89rB7a04pqDfuE6QFAViLyWy
         hli//fs1rJYxaYI1i1Q0crJXB84OXHw+TuLF/L9s=
Date:   Fri, 14 Jul 2023 21:00:29 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [PATCH RFC v10 9/17] ipe: add permissive toggle
Message-ID: <20230715040029.GH15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-10-git-send-email-wufan@linux.microsoft.com>
 <85af33c02638ebb501b40fd0f3785b12.paul@paul-moore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85af33c02638ebb501b40fd0f3785b12.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Jul 08, 2023 at 12:23:06AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > IPE, like SELinux, supports a permissive mode. This mode allows policy
> > authors to test and evaluate IPE policy without it effecting their
> > programs. When the mode is changed, a 1404 AUDIT_MAC_STATUS
> > be reported.
> > 
> > This patch adds the following audit records:
> > 
> >     audit: MAC_STATUS enforcing=0 old_enforcing=1 auid=4294967295
> >       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
> >     audit: MAC_STATUS enforcing=1 old_enforcing=0 auid=4294967295
> >       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
> > 
> > The audit record only emit when the value from the user input is
> > different from the current enforce value.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/audit.c | 22 ++++++++++++++
> >  security/ipe/audit.h |  1 +
> >  security/ipe/eval.c  |  9 ++++++
> >  security/ipe/eval.h  |  1 +
> >  security/ipe/fs.c    | 69 ++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 102 insertions(+)
> 
> ...
> 
> > diff --git a/security/ipe/fs.c b/security/ipe/fs.c
> > index 6bd2aa84831b..1761d39e4d04 100644
> > --- a/security/ipe/fs.c
> > +++ b/security/ipe/fs.c
> > @@ -16,6 +16,7 @@ static struct dentry *np __ro_after_init;
> >  static struct dentry *root __ro_after_init;
> >  struct dentry *policy_root __ro_after_init;
> >  static struct dentry *audit_node __ro_after_init;
> > +static struct dentry *enforce_node __ro_after_init;
> >  
> >  /**
> >   * setaudit - Write handler for the securityfs node, "ipe/success_audit"
> > @@ -68,6 +69,61 @@ static ssize_t getaudit(struct file *f, char __user *data,
> >  	return simple_read_from_buffer(data, len, offset, result, 1);
> >  }
> >  
> > +/**
> > + * setenforce - Write handler for the securityfs node, "ipe/enforce"
> > + * @f: Supplies a file structure representing the securityfs node.
> > + * @data: Supplies a buffer passed to the write syscall.
> > + * @len: Supplies the length of @data.
> > + * @offset: unused.
> > + *
> > + * Return:
> > + * * >0	- Success, Length of buffer written
> > + * * <0	- Error
> > + */
> > +static ssize_t setenforce(struct file *f, const char __user *data,
> > +			  size_t len, loff_t *offset)
> > +{
> > +	int rc = 0;
> > +	bool new_value, old_value;
> > +
> > +	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
> > +		return -EPERM;
> > +
> > +	old_value = READ_ONCE(enforce);
> > +	new_value = old_value;
> 
> Why set @new_value equal to @old_value here?
> 
Sorry this mistake is the same as the one for audit switch. 
kstrtobool_from_user will return error if new_value is not set,
I will remove the above line.

-Fan
> > +	rc = kstrtobool_from_user(data, len, &new_value);
> > +	if (rc)
> > +		return rc;
> > +
> > +	if (new_value != old_value) {
> > +		ipe_audit_enforce(new_value, old_value);
> > +		WRITE_ONCE(enforce, new_value);
> > +	}
> > +
> > +	return len;
> > +}
> 
> --
> paul-moore.com
