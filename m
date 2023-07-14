Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71417754585
	for <lists+linux-fscrypt@lfdr.de>; Sat, 15 Jul 2023 01:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjGNX7E (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 14 Jul 2023 19:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjGNX7D (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 14 Jul 2023 19:59:03 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 089F73A95;
        Fri, 14 Jul 2023 16:59:02 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 8332121C4688; Fri, 14 Jul 2023 16:59:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8332121C4688
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1689379141;
        bh=2C4m2YJgTT1MEEWz1nhcSN6gGPbVmDeNLUSX4y5ThPk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TSRovlH7VT4nPOdahJZZ5eCb3H/XGNJmz67QS2nn6JmdTwIn2lhLlzsH9qhJxufCk
         3erLzQd/gFCxjBBcQys3yiE+nLgYByqb2isNagpgjILAhYUxO7clRf5VLNXJdrbwFW
         HoRY05gZSAXjbZR+W6BU3c968oduDljFxGQHR/ak=
Date:   Fri, 14 Jul 2023 16:59:01 -0700
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
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v10 6/17] security: add new securityfs delete function
Message-ID: <20230714235901.GE15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-7-git-send-email-wufan@linux.microsoft.com>
 <80ae988288d2ac277a4429e85524a9bb.paul@paul-moore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80ae988288d2ac277a4429e85524a9bb.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Jul 08, 2023 at 12:23:03AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > When deleting a directory in the security file system, the existing
> > securityfs_remove requires the directory to be empty, otherwise
> > it will do nothing. This leads to a potential risk that the security
> > file system might be in an unclean state when the intentded deletion
> > did not happen.
> > 
> > This commit introduces a new function securityfs_recursive_remove
> > to recursively delete a directory without leaving an unclean state.
> > 
> > Co-developed-by: "Christian Brauner (Microsoft)" <brauner@kernel.org>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  include/linux/security.h |  1 +
> >  security/inode.c         | 25 +++++++++++++++++++++++++
> >  2 files changed, 26 insertions(+)
> > 
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index e2734e9e44d5..a88076ebc7b1 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -1971,6 +1971,7 @@ struct dentry *securityfs_create_symlink(const char *name,
> >  					 const char *target,
> >  					 const struct inode_operations *iops);
> >  extern void securityfs_remove(struct dentry *dentry);
> > +extern void securityfs_recursive_remove(struct dentry *dentry);
> >  
> >  #else /* CONFIG_SECURITYFS */
> >  
> > diff --git a/security/inode.c b/security/inode.c
> > index 6c326939750d..13358e8547e8 100644
> > --- a/security/inode.c
> > +++ b/security/inode.c
> > @@ -313,6 +313,31 @@ void securityfs_remove(struct dentry *dentry)
> >  }
> >  EXPORT_SYMBOL_GPL(securityfs_remove);
> >  
> > +static void remove_one(struct dentry *victim)
> > +{
> > +	simple_release_fs(&mount, &mount_count);
> > +}
> > +
> > +/**
> > + * securityfs_recursive_remove - recursively removes a file or directory from the securityfs filesystem
> 
> I really want to see lines less than or equal to 80 characters; I
> would suggest this:
> 
> "securityfs_recursive_remove - recursively removes a file or directory"
> 
Thanks for the suggestion, I will make the change accordingly.

-Fan
> > + * @dentry: a pointer to a the dentry of the file or directory to be removed.
> > + *
> > + * This function recursively removes a file or directory in securityfs that was
> > + * previously created with a call to another securityfs function (like
> > + * securityfs_create_file() or variants thereof.)
> > + */
> > +void securityfs_recursive_remove(struct dentry *dentry)
> > +{
> > +	if (IS_ERR_OR_NULL(dentry))
> > +		return;
> > +
> > +	simple_pin_fs(&fs_type, &mount, &mount_count);
> > +	simple_recursive_removal(dentry, remove_one);
> > +	simple_release_fs(&mount, &mount_count);
> > +}
> > +EXPORT_SYMBOL_GPL(securityfs_recursive_remove);
> > +
> >  #ifdef CONFIG_SECURITY
> >  static struct dentry *lsm_dentry;
> >  static ssize_t lsm_read(struct file *filp, char __user *buf, size_t count,
> > -- 
> > 2.25.1
> 
> --
> paul-moore.com
